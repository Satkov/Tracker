import Foundation
import CoreData

final class RecordsDataProvider: NSObject {
    
    weak var delegate: RecordsDataProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let trackerID: UUID
    
    private lazy var fetchedResultsController: NSFetchedResultsController<RecordCoreData> = {
        let fetchRequest = NSFetchRequest<RecordCoreData>(entityName: "RecordCoreData")
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@", trackerID as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    init(trackerID: UUID, context: NSManagedObjectContext, delegate: RecordsDataProviderDelegate?) {
        self.trackerID = trackerID
        self.context = context
        self.delegate = delegate
        super.init()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("LOG: Ошибка загрузки записей: \(error.localizedDescription)")
        }
    }
    
    var recordCount: Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func hasRecord(for date: Date) -> Bool {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return fetchedResultsController.fetchedObjects?.contains(where: { $0.date == startOfDay }) ?? false
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension RecordsDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.recordsDidUpdate(for: trackerID)
    }
}
