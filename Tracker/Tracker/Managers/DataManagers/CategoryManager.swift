import Foundation
import CoreData

final class TrackerCategoryManager {
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.context
    
    // Добавление новой категории
    func addCategory(_ category: TrackerCategoryModel) {
        let categoryCoreData = CategoryCoreData(context: context)
        categoryCoreData.name = category.categoryName
        coreDataManager.saveContext()
    }
    
    
    func loadCategories() -> [TrackerCategoryModel] {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        
        do {
            let categoriesCoreData = try context.fetch(request)
            
            return categoriesCoreData.map { category -> TrackerCategoryModel in
                let trackers: [TrackerModel] = (category.trackers as? Set<TrackerCoreData>)?.compactMap { tracker -> TrackerModel? in
                    let decodedSchedule: Set<Schedule>
                    
                    if let scheduleData = tracker.schedule,
                       let scheduleSet = try? JSONDecoder().decode(Set<Schedule>.self, from: scheduleData) {
                        decodedSchedule = scheduleSet
                    } else {
                        decodedSchedule = []
                    }

                    return TrackerModel(
                        id: tracker.id ?? UUID(),
                        name: tracker.name ?? "",
                        color: TrackerColors(rawValue: tracker.color ?? "") ?? .red,
                        emoji: Emojis(rawValue: tracker.emoji ?? "") ?? .smilingFace,
                        schedule: decodedSchedule
                    )
                } ?? []
                
                return TrackerCategoryModel(
                    categoryName: category.name ?? "Без названия",
                    trackers: trackers
                )
            }
        } catch {
            print("Ошибка загрузки категорий: \(error.localizedDescription)")
            return []
        }
    }
    
    func getCategories(for day: Schedule) -> [TrackerCategoryModel] {
        let categories = self.loadCategories()
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
    
    func hasAnyTrackers(for day: Schedule) -> Bool {
        let categories = self.loadCategories()
        return categories.contains { category in
            category.trackers.contains { tracker in
                tracker.schedule?.contains(day) ?? false
            }
        }
        
    }
    
    func loadCategoriesWithTrackers() -> [TrackerCategoryModel] {
        let categories = self.loadCategories()
        return categories.filter { !$0.trackers.isEmpty }
        
    }
}
