import CoreData

protocol TrackerDataStoreProtocol {
    func add(tracker: TrackerModel, categoryName: String) throws
    func delete(_ record: NSManagedObject) throws
}
