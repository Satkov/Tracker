import Foundation

class TrackerCategoryManager {
    private let userDefaults = UserDefaults.standard
    private let userDefaultsQueue = DispatchQueue(label: "userDefaultsQueue")
    private let categoriesKey = "trackerCategoriesKey3"
    
    // Загрузка категорий
    func loadCategories() -> [TrackerCategoryModel] {
        return userDefaultsQueue.sync {
            guard let data = userDefaults.data(forKey: categoriesKey) else {
                return []
            }
            let decoder = JSONDecoder()
            return (try? decoder.decode([TrackerCategoryModel].self, from: data)) ?? []
        }
    }
    
    // Сохранение категорий
    func saveCategories(_ categories: [TrackerCategoryModel]) {
        userDefaultsQueue.sync {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(categories) {
                userDefaults.set(data, forKey: categoriesKey)
            }
        }
    }
    
    // Добавление новой категории
    func addCategory(_ category: TrackerCategoryModel) {
        var categories = loadCategories()
        categories.append(category)
        saveCategories(categories)
    }
    
    // Удаление категории
    func removeCategory(byName name: String) {
        var categories = loadCategories()
        categories.removeAll { $0.categoryName == name }
        saveCategories(categories)
    }
    
    // Добавление трекера в категорию
    func addTracker(to categoryName: String, tracker: TrackerModel) {
        var categories = loadCategories()
        if let index = categories.firstIndex(where: { $0.categoryName == categoryName }) {
            var trackers = categories[index].trackers
            trackers.append(tracker)
            var newCategory = TrackerCategoryModel(categoryName: categories[index].categoryName, trackers: trackers)
            categories[index] = newCategory
            saveCategories(categories)
        }
    }
    
    // Удаление трекера из категории
    func removeTracker(from categoryName: String, trackerID: UUID) {
        var categories = loadCategories()
        if let index = categories.firstIndex(where: { $0.categoryName == categoryName }) {
            var trackers = categories[index].trackers
            trackers.removeAll { $0.id == trackerID }
            var newCategory = TrackerCategoryModel(categoryName: categories[index].categoryName, trackers: trackers)
            categories[index] = newCategory
            saveCategories(categories)
        }
    }
}
