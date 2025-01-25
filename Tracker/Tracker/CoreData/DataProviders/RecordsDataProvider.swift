import Foundation
import CoreData

final class RecordsDataProvider: NSObject {
    
    weak var delegate: RecordsDataProviderDelegate?
    
    private let recordsDataStore: RecordsDataStore
    private let trackerID: UUID
    
    init(
        trackerID: UUID,
        context: NSManagedObjectContext,
        delegate: RecordsDataProviderDelegate?)
    {
        self.trackerID = trackerID
        self.recordsDataStore = RecordsDataStore(context: context)
        self.delegate = delegate
        super.init()
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
    }
}


extension RecordsDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.recordsDidUpdate(for: trackerID)
    }
}
