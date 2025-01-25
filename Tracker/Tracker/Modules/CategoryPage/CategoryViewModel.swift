import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    // MARK: - Properties
    private var categories: [TrackerCategoryModel] = []
    private var model: CategoryDataProvider?
    var onNumberOfCategoriesState: Binding<Bool>?
    var lastSelectedCategory: TrackerCategoryModel?
    
    // MARK: - Initialization
    init() {
        model = CategoryDataProvider(delegate: self)
        loadCategories()
    }
    
    // MARK: - Data Loading
    private func loadCategories() {
        guard let model = model else { return }
        
        categories = model.getCategories().map {
            TrackerCategoryModel(categoryName: $0.name ?? "")
        }
        
        onNumberOfCategoriesState?(categories.isEmpty)
    }
    
    // MARK: - Category Management
    func categorySelected(
        indexPath: IndexPath,
        completion: (_ selectedCategory: TrackerCategoryModel) -> Void
    ) {
        let selectedCategory = categories[indexPath.row]
        lastSelectedCategory = selectedCategory
        completion(selectedCategory)
    }
    
    // MARK: - Data Access
    func numberOfCategories() -> Int {
        categories.count
    }
    
    func getDataForCell(indexPath: IndexPath) -> DataForCell {
        let category = categories[indexPath.row]
        let isSelected = lastSelectedCategory?.categoryName == category.categoryName
        
        return DataForCell(
            categoryName: category.categoryName,
            isSelected: isSelected,
            isLast: indexPath.row == categories.count - 1,
            isFirst: indexPath.row == 0
        )
    }
}

// MARK: - CategoryDataProviderDelegate
extension CategoryViewModel: CategoryDataProviderDelegate {
    func categoriesDidUpdate() {
        loadCategories()
    }
}
