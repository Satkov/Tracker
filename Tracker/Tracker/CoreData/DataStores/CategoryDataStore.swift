import Foundation
import CoreData

final class CategoryDataStore {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    func add(name: String) throws {
        let category = CategoryCoreData(context: context)
        category.name = name

        do {
            try context.save()
        } catch {
            throw error
        }
    }
}
