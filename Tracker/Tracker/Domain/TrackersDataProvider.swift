import Foundation
import CoreData

// MARK: - DataProvider
final class TrackersDataProvider: NSObject {
    
    enum DataProviderError: Error {
        case failedToInitializeContext
    }
    
    weak var delegate: DataProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let dataStore: TrackerDataStore
    
    private var choosenDate = Date()

    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.name",
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    init(_ dataStore: TrackerDataStore, delegate: DataProviderDelegate) throws {
        let context = CoreDataManager.shared.context
        self.delegate = delegate
        self.context = context
        self.dataStore = dataStore
        super.init()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("LOG: Ошибка загрузки данных: \(error.localizedDescription)")
        }
    }
}

// MARK: - TrackersDataProviderProtocol
extension TrackersDataProvider: TrackersDataProviderProtocol {
    func updateDate(_ newDate: Date) {
        choosenDate = newDate
        filterByDate()
    }
    
    private func filterByDate() {
        // получаю трекеры на выбранную дату
        let scheduleDay = Schedule.dayOfWeek(for: choosenDate)
        
        let filteredTrackers = fetchedResultsController.fetchedObjects?.filter { tracker in
            if let scheduleData = tracker.schedule,
               let decodedSchedule = try? JSONDecoder().decode([Schedule].self, from: scheduleData) {
                return decodedSchedule.contains(scheduleDay)
            }
            return false
        } ?? []
        
        delegate?.didUpdate()
    }
    
    var numberOfSections: Int {
        return filteredSections().count
    }

    // получаю только секции в которых есть трекер на выбраную в дейтпикер дату
    private func filteredSections() -> [NSFetchedResultsSectionInfo] {
        guard let sections = fetchedResultsController.sections else { return [] }

        let scheduleDay = Schedule.dayOfWeek(for: choosenDate)

        return sections.filter { section in
            guard let objects = section.objects as? [TrackerCoreData] else { return false }
            return objects.contains { tracker in
                if let scheduleData = tracker.schedule,
                   let decodedSchedule = try? JSONDecoder().decode([Schedule].self, from: scheduleData) {
                    return decodedSchedule.contains(scheduleDay)
                }
                return false
            }
        }
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        let scheduleDay = Schedule.dayOfWeek(for: choosenDate)
        let sections = filteredSections()

        guard section < sections.count else { return 0 }

        return sections[section].objects?.filter { object in
            if let tracker = object as? TrackerCoreData,
               let scheduleData = tracker.schedule,
               let decodedSchedule = try? JSONDecoder().decode([Schedule].self, from: scheduleData) {
                return decodedSchedule.contains(scheduleDay)
            }
            return false
        }.count ?? 0
    }

    func sectionName(for section: Int) -> String {
        let sections = filteredSections()
        return section < sections.count ? sections[section].name : ""
    }

    func trackerObject(at indexPath: IndexPath) -> TrackerModel? {
        let scheduleDay = Schedule.dayOfWeek(for: choosenDate)
        let sections = filteredSections()

        guard indexPath.section < sections.count,
              let objects = sections[indexPath.section].objects as? [TrackerCoreData] else { return nil }

        let filteredTrackers = objects.filter { tracker in
            if let scheduleData = tracker.schedule,
               let decodedSchedule = try? JSONDecoder().decode([Schedule].self, from: scheduleData) {
                return decodedSchedule.contains(scheduleDay)
            }
            return false
        }

        guard indexPath.row < filteredTrackers.count else { return nil }
        let trackerCoreData = filteredTrackers[indexPath.row]

        return TrackerModel(
            id: trackerCoreData.id ?? UUID(),
            name: trackerCoreData.name ?? "",
            color: TrackerColors(rawValue: trackerCoreData.color ?? "") ?? .red,
            emoji: Emojis(rawValue: trackerCoreData.emoji ?? "") ?? .smilingFace,
            schedule: Set(filteredTrackers.compactMap { tracker in
                if let scheduleData = tracker.schedule,
                   let decodedSchedule = try? JSONDecoder().decode([Schedule].self, from: scheduleData) {
                    return decodedSchedule
                }
                return nil
            }.joined())
        )
    }

    func addTracker(to categoryName: String, trackerModel: TrackerModel) throws {
        try dataStore.add(tracker: trackerModel, categoryName: categoryName)
    }
    
    func deleteTracker(at indexPath: IndexPath) throws {
        let tracker = fetchedResultsController.object(at: indexPath)
        try dataStore.delete(tracker)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        filterByDate()
        delegate?.didUpdate()
    }
}
