import Foundation

final class TrackerCategoryManager {
    private var categories: [TrackerCategoryModel] = []
    private let queue = DispatchQueue(label: "trackerCategoryQueue", attributes: .concurrent)
    static let shared = TrackerCategoryManager()

    private init() {}

    // Загрузка категорий
    func loadCategories() -> [TrackerCategoryModel] {
        queue.sync {
            return categories
        }
    }

    func getCategories(for day: Schedule) -> [TrackerCategoryModel] {
        queue.sync {
            return categories.compactMap { category in
                let filteredTrackers = category.trackers.filter { tracker in
                    guard let schedule = tracker.schedule else { return false }
                    return schedule.contains(day)
                }
                return filteredTrackers.isEmpty ? nil : TrackerCategoryModel(
                    categoryName: category.categoryName,
                    trackers: filteredTrackers
                )
            }
        }
    }

    func hasAnyTrackers(for day: Schedule) -> Bool {
        queue.sync {
            return categories.contains { category in
                category.trackers.contains { tracker in
                    tracker.schedule?.contains(day) ?? false
                }
            }
        }
    }

    // Загрузка категорий с трекерами
    func loadCategoriesWithTrackers() -> [TrackerCategoryModel] {
        queue.sync {
            return categories.filter { !$0.trackers.isEmpty }
        }
    }

    // Добавление новой категории
    func addCategory(_ category: TrackerCategoryModel) {
        queue.async(flags: .barrier) {
            self.categories.append(category)
        }
    }

    // Удаление категории
    func removeCategory(byName name: String) {
        queue.async(flags: .barrier) {
            self.categories.removeAll { $0.categoryName == name }
        }
    }

    // Добавление трекера в категорию
    func addTracker(to categoryName: String, tracker: TrackerModel) {
        queue.async(flags: .barrier) {
            if let index = self.categories.firstIndex(where: { $0.categoryName == categoryName }) {
                var trackers = self.categories[index].trackers
                trackers.append(tracker)
                let newCategory = TrackerCategoryModel(
                    categoryName: self.categories[index].categoryName, trackers: trackers
                )
                self.categories[index] = newCategory
            }
        }
    }

    // Удаление трекера из категории
    func removeTracker(from categoryName: String, trackerID: UUID) {
        queue.async(flags: .barrier) {
            if let index = self.categories.firstIndex(where: { $0.categoryName == categoryName }) {
                var trackers = self.categories[index].trackers
                trackers.removeAll { $0.id == trackerID }
                let newCategory = TrackerCategoryModel(
                    categoryName: self.categories[index].categoryName, trackers: trackers
                )
                self.categories[index] = newCategory
            }
        }
    }
}
