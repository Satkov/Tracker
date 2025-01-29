import Foundation
import CoreData

// MARK: - DataProvider
final class TrackersDataProvider: NSObject {
    weak var delegate: DataProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let dataStore: TrackerDataStore
    
    private var categories: [TrackerCategoryModel] = []
    private var textInSearchBar = ""
    private var lastFilter = FilterSettings(date: Calendar.current.startOfDay(for: Date()),
                                            trackerName: "",
                                            recorded: .all)

    // использую, чтобы следить за обновлениями coredata
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.name",
            cacheName: nil
        )
    }()

    init(_ dataStore: TrackerDataStore, delegate: DataProviderDelegate) throws {
        let context = CoreDataManager.shared.context
        self.delegate = delegate
        self.context = context
        self.dataStore = dataStore
        super.init()
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Ошибка загрузки записей: \(error)")
        }
    }

    private func loadCategoriesWithTrackers(for date: Date) {
        do {
            categories = try dataStore.fetchCategoriesWithTrackers(for: date)
        } catch {
            // TODO: error
        }
    }
    
    func filterTrackers(filters: FilterSettings) {
        lastFilter = filters
        loadCategoriesWithTrackers(for: filters.date)
        TrackersFilters.movePinnedToCompleted(in: &categories)
        TrackersFilters.filterAndSortCategories(by: filters.trackerName, in: &categories)
        TrackersFilters.filterByRecordStatus(in: &categories,
                                             status: filters.recorded,
                                             date: filters.date,
                                             recordsDataStore: RecordsDataStore())
        delegate?.didUpdate()
    }
    
    
    // MARK: - Методы для UI
    var numberOfSections: Int {
        return categories.count
    }

    func numberOfRowsInSection(_ section: Int) -> Int {
        return categories[section].trackers.count
    }

    func sectionName(for section: Int) -> String {
        return categories[section].categoryName
    }

    func trackerObject(at indexPath: IndexPath) -> TrackerModel? {
        return categories[indexPath.section].trackers[indexPath.row]
    }
    
    func getCategoryNameForTrackerBy(id: UUID) ->  String? {
        return try? dataStore.fetchCategoryName(for: id)
    }

    // MARK: - Управление трекерами
    func addTracker(to categoryName: String, trackerModel: TrackerModel) throws {
        try dataStore.add(tracker: trackerModel, categoryName: categoryName)
    }
    
    func updateTracker(_ tracker: TrackerModel, in category: TrackerCategoryModel) {
        try? dataStore.updateTracker(tracker, in: category)
    }
    
    func deleteTracker(at indexPath: IndexPath) throws {
        let trackerModel = categories[indexPath.section].trackers[indexPath.row]

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
    
    func togglePinTracker(for tracker: TrackerModel) {
        try? dataStore.togglePin(for: tracker)
        filterTrackers(filters: lastFilter)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackersDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("asdasdasd")
        filterTrackers(filters: lastFilter)
    }
}
