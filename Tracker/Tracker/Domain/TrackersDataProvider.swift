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
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var insertedSections: IndexSet?
    private var deletedSections: IndexSet?

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
    var numberOfSections: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func sectionName(for section: Int) -> String {
        return fetchedResultsController.sections?[section].name ?? "Без категории"
    }
    
    func trackerObject(at indexPath: IndexPath) -> TrackerModel? {
        let trackerCoreData = fetchedResultsController.object(at: indexPath)
        var schedule: Set<Schedule> = []
        if let scheduleCoreData = trackerCoreData.schedule,
           let decodedSchedule = try? JSONDecoder().decode(Set<Schedule>.self, from: scheduleCoreData) {
            schedule = decodedSchedule
        }
        return TrackerModel(
            id: trackerCoreData.id ?? UUID(),
            name: trackerCoreData.name ?? "",
            color: TrackerColors(rawValue: trackerCoreData.color ?? "") ?? .red,
            emoji: Emojis(rawValue: trackerCoreData.emoji ?? "") ?? .smilingFace,
            schedule: schedule
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
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        insertedSections = IndexSet()
        deletedSections = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            StoreUpdate(
                insertedIndexes: insertedIndexes ?? IndexSet(),
                deletedIndexes: deletedIndexes ?? IndexSet(),
                updatedIndexes: updatedIndexes ?? IndexSet(),
                insertedSections: insertedSections ?? IndexSet(),
                deletedSections: deletedSections ?? IndexSet()
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        insertedSections = nil
        deletedSections = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        case .update:
            if let indexPath = indexPath {
                updatedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .delete:
            deletedSections?.insert(sectionIndex)
        case .insert:
            insertedSections?.insert(sectionIndex)
        default:
            break
        }
    }
}
