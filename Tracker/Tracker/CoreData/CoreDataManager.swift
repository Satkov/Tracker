import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "TrackerCoreData")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                // TODO: обработка ошибки
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: обработка ошибки
            }
        }
    }
}
