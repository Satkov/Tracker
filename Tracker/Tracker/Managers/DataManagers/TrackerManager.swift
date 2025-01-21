import Foundation
import CoreData

final class TrackerManager {
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.context
    
    // Добавление трекера в категорию
    func addTracker(to categoryName: String, trackerModel: TrackerModel) {
        let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", categoryName)
        
        do {
            if let category = try context.fetch(request).first {
                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.id = trackerModel.id
                trackerCoreData.name = trackerModel.name
                trackerCoreData.color = trackerModel.color.rawValue
                trackerCoreData.emoji = trackerModel.emoji.rawValue
                
                if let scheduleData = try? JSONEncoder().encode(trackerModel.schedule) {
                    trackerCoreData.schedule = scheduleData
                } else {
                    print("LOG: Ошибка при кодировании расписания")
                }
                category.addToTrackers(trackerCoreData)
                
                try context.save()
                print("LOG: Трекер успешно добавлен в категорию '\(categoryName)'!")
            } else {
                print("LOG: Категория '\(categoryName)' не найдена.")
            }
        } catch {
            print("LOG: Ошибка при добавлении трекера: \(error.localizedDescription)")
        }
    }
}
