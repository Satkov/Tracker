import CoreData

// MARK: - DataStore
final class TrackerDataStore {
    
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
    }
    
    init() {
        self.context = CoreDataManager.shared.context
    }
    
    private func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
}

// MARK: - NotepadDataStore
extension TrackerDataStore: TrackerDataStoreProtocol {
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
    
    func add(tracker: TrackerModel, categoryName: String) throws {
        try performSync { context in
            Result {
                let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "name = %@", categoryName)
                
                guard let categoryCoreData = try context.fetch(request).first else { return }
                
                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.id = tracker.id
                trackerCoreData.name = tracker.name
                trackerCoreData.color = tracker.color.rawValue
                trackerCoreData.emoji = tracker.emoji.rawValue
                
                if let schedule = tracker.schedule, let scheduleData = try? JSONEncoder().encode(schedule) {
                    trackerCoreData.schedule = scheduleData
                } else {
                    trackerCoreData.schedule = nil
                }
                
                categoryCoreData.mutableSetValue(forKey: "trackers").add(trackerCoreData)
                
                CoreDataManager.shared.saveContext()
            }
        }
    }
    
    
    func delete(_ tracker: NSManagedObject) throws {
        try performSync { context in
            Result {
                let objectInContext = context.object(with: tracker.objectID)
                context.delete(objectInContext)
                try context.save()
            }
        }
    }
}
