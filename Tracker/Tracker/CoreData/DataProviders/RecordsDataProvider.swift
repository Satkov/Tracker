import Foundation
import CoreData

final class RecordsDataProvider: NSObject {

    weak var delegate: RecordsDataProviderDelegate?

    private let recordsDataStore: RecordsDataStore
    private let trackerID: UUID
    private let context: NSManagedObjectContext

    private lazy var fetchedResultsController: NSFetchedResultsController<RecordCoreData> = {
        let fetchRequest: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@", trackerID as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()

    init(
        trackerID: UUID,
        context: NSManagedObjectContext,
        delegate: RecordsDataProviderDelegate?) {
        self.trackerID = trackerID
        self.context = context
        self.recordsDataStore = RecordsDataStore(context: context)
        self.delegate = delegate
        super.init()

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Ошибка загрузки записей: \(error)")
        }
    }

    // MARK: - API для работы с записями
    var recordCount: Int {
        return recordsDataStore.countRecords(for: trackerID)
    }

    func hasRecord(for date: Date) -> Bool {
        return recordsDataStore.hasRecord(trackerID: trackerID, date: date)
    }

    func toggleRecord(for date: Date) {
        let record = TrackerRecordModel(trackerID: trackerID, date: date)
        recordsDataStore.toggleRecord(record)

        do {
            try context.save()
        } catch {
            print("Ошибка сохранения после toggleRecord: \(error)")
        }
    }
}

extension RecordsDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("🔄 Данные изменились для трекера \(trackerID)")
        delegate?.recordsDidUpdate(for: trackerID)
    }
}
