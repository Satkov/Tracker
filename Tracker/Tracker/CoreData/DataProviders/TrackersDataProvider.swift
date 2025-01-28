import Foundation
import CoreData

// MARK: - DataProvider
final class TrackersDataProvider: NSObject {
    weak var delegate: DataProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let dataStore: TrackerDataStore
    
    private var choosenDate = Calendar.current.startOfDay(for: Date())
    private var categories: [TrackerCategoryModel] = []
    private var trackers: [TrackerModel] = []
    private var textInSearchBar = ""

    // использую, чтобы следить за обновлениями coredata
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
        loadData()
    }

    // загружаю данные из coredata в массивы
    private func loadData() {
        do {
            try fetchedResultsController.performFetch()
            updateMemoryCache()
        } catch {
            // TODO: обработка ошибки
        }
    }

    private func updateMemoryCache() {
        /* Обновляю локальный кэш категорий и трекеров, взяв их из coredata
         сортирую трекеры и категории, чтобы они не перемешивались при обновлении
         группирую и добавляю в массив categories все непустые категории
         помещаю все доступные трекеры в массив trackers */
        guard let objects = fetchedResultsController.fetchedObjects else { return }

        var newCategories: [TrackerCategoryModel] = []
        var categoryMap: [String: [TrackerModel]] = [:]

        for tracker in objects {
            guard let categoryName = tracker.category?.name else { continue }

            let trackerModel = convertToTrackerModel(tracker)
            categoryMap[categoryName, default: []].append(trackerModel)
        }

        for (categoryName, trackers) in categoryMap {
            let sortedTrackers = trackers.sorted {
                if $0.isPinned == $1.isPinned {
                    return $0.name < $1.name
                }
                return $0.isPinned && !$1.isPinned
            }
            newCategories.append(
                TrackerCategoryModel(
                    categoryName: categoryName,
                    trackers: sortedTrackers
                )
            )
        }

        categories = newCategories.sorted { $0.categoryName < $1.categoryName }
        trackers = objects.compactMap { convertToTrackerModel($0) }
            .sorted {
                if $0.isPinned == $1.isPinned {
                    return $0.name < $1.name
                }
                return $0.isPinned && !$1.isPinned
            }

        delegate?.didUpdate()
    }
    
    // MARK: - Фильтрация данных
    func updateDate(_ newDate: Date) {
        /* метод дергается, когда в дейтпикере меняется дата */
        choosenDate = newDate
        delegate?.didUpdate()
    }
    
    func updateSearchBarText(_ text: String) {
        textInSearchBar = text
        delegate?.didUpdate()
    }
    
    func togglePinTracker(at indexPath: IndexPath) throws {
        let trackerModel = filteredSections()[indexPath.section].trackers[indexPath.row]

        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerModel.id as CVarArg)

        do {
            if let trackerCoreData = try context.fetch(request).first {
                trackerCoreData.isPinned.toggle()
                try context.save()
                updateMemoryCache()
            } else {
                // TODO: обработка ошибки
            }
        } catch {
            // TODO: обработка ошибки
        }
    }
    
    private func filteredTrackers() -> [TrackerModel] {
        // возвращает массив трекеров, которые соответствуют выбраной дате
        let scheduleDay = Schedule.dayOfWeek(for: choosenDate)
        return trackers.filter { tracker in
            guard let schedule = tracker.schedule else { return false }
            
            if !textInSearchBar.isEmpty {
                return schedule.contains(scheduleDay) &&
                       tracker.name.contains(textInSearchBar)
            }
            
            return schedule.contains(scheduleDay)
        }
    }

    // MARK: - Методы для UI
    var numberOfSections: Int {
        return filteredSections().count
    }

    private func filteredSections() -> [TrackerCategoryModel] {
        return categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                guard let schedule = tracker.schedule else { return false }
                if !textInSearchBar.isEmpty {
                    return schedule.contains(Schedule.dayOfWeek(for: choosenDate)) &&
                           tracker.name.contains(textInSearchBar)
                }
                return schedule.contains(Schedule.dayOfWeek(for: choosenDate))
            }
            
            // закрепленные трекеры сверху
            let sortedTrackers = filteredTrackers.sorted {
                if $0.isPinned == $1.isPinned {
                    return $0.name < $1.name
                }
                return $0.isPinned && !$1.isPinned
            }

            return sortedTrackers.isEmpty ? nil : TrackerCategoryModel(
                categoryName: category.categoryName,
                trackers: sortedTrackers
            )
        }
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        return filteredSections()[section].trackers.count
    }

    func sectionName(for section: Int) -> String {
        return filteredSections()[section].categoryName
    }

    func trackerObject(at indexPath: IndexPath) -> TrackerModel? {
        return filteredSections()[indexPath.section].trackers[indexPath.row]
    }

    // MARK: - Управление трекерами
    func addTracker(to categoryName: String, trackerModel: TrackerModel) throws {
        try dataStore.add(tracker: trackerModel, categoryName: categoryName)
    }
    
    func deleteTracker(at indexPath: IndexPath) throws {
        let trackerModel = filteredSections()[indexPath.section].trackers[indexPath.row]

        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", trackerModel.id as CVarArg)

        do {
            if let trackerCoreData = try context.fetch(request).first {
                try dataStore.delete(trackerCoreData)
            } else {
                // TODO: обработка ошибки
            }
        } catch {
            // TODO: обработка ошибки
        }
    }

    private func convertToTrackerModel(_ trackerCoreData: TrackerCoreData) -> TrackerModel {
        let schedule: Set<Schedule> = {
            if let scheduleData = trackerCoreData.schedule,
               let decodedSchedule = try? JSONDecoder().decode(Set<Schedule>.self, from: scheduleData) {
                return decodedSchedule
            }
            return []
        }()
        
        return TrackerModel(
            id: trackerCoreData.id ?? UUID(),
            name: trackerCoreData.name ?? "",
            color: TrackerColors(rawValue: trackerCoreData.color ?? "") ?? .red,
            emoji: Emojis(rawValue: trackerCoreData.emoji ?? "") ?? .smilingFace,
            schedule: schedule
        )
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMemoryCache()
    }
}
