import Foundation
import CoreData

protocol CategoryDataProviderDelegate: AnyObject {
    func categoriesDidUpdate()
}

final class CategoryDataProvider: NSObject {
    
    private let categoryDataStore = CategoryDataStore()
    private let context: NSManagedObjectContext
    weak var delegate: CategoryDataProviderDelegate?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<CategoryCoreData> = {
        let fetchRequest: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()
    
    init(delegate: CategoryDataProviderDelegate?) {
        self.context = CoreDataManager.shared.context
        self.delegate = delegate
        super.init()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            // TODO: обработка ошибки
        }
    }
    
    // MARK: - Добавление категории
    func addCategory(name: String) throws {
        try categoryDataStore.add(name: name)
    }
    
    // MARK: - Получение списка категорий
    func getCategories() -> [CategoryCoreData] {
        return fetchedResultsController.fetchedObjects ?? []
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.categoriesDidUpdate()
    }
}
