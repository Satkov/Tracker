import CoreData

protocol TrackerDataStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? { get }
    func add(tracker: TrackerModel, categoryName: String) throws
    func delete(_ record: NSManagedObject) throws
}
