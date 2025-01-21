import Foundation
import CoreData

final class RecordManager {
    private let coreDataManager = CoreDataManager.shared
    private let context = CoreDataManager.shared.context
    
    func loadRecords() -> [TrackerRecordModel] {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        
        do {
            let recordsCoreData = try context.fetch(request)
            
            let records = recordsCoreData.compactMap { record -> TrackerRecordModel? in
                guard let tracker = record.tracker,
                      let trackerID = tracker.id,
                      let date = record.date else {
                    return nil
                }
                return TrackerRecordModel(
                    trackerID: trackerID,
                    date: date
                )
            }
            
            print("LOG: Загружено записей: \(records.count)")
            return records
            
        } catch {
            print("LOG: Ошибка загрузки записей: \(error.localizedDescription)")
            return []
        }
    }
    
    func addRecord(_ record: TrackerRecordModel) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.trackerID as CVarArg)
        print("LOG: ", TrackerCategoryManager().loadCategories())
        do {
            if let tracker = try context.fetch(request).first {
                let recordCoreData = RecordCoreData(context: context)
                recordCoreData.date = record.date
                recordCoreData.tracker = tracker
                
                try context.save()
                print("LOG: Запись добавлена для трекера \(record.trackerID) на дату \(record.date).")
            } else {
                print("LOG: Ошибка: Трекер с ID \(record.trackerID) не найден.")
            }
        } catch {
            print("LOG: Ошибка при добавлении записи: \(error.localizedDescription)")
        }
    }
    
    // Удаление записи по ID трекера и дате
    func removeRecord(byTrackerId id: UUID, date: Date) {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", id as CVarArg, startOfDay as CVarArg)
        
        do {
            let recordsToDelete = try context.fetch(request)
            
            if recordsToDelete.isEmpty {
                print("LOG: Запись для трекера с ID \(id) на дату \(startOfDay) не найдена.")
                return
            }
            
            for record in recordsToDelete {
                context.delete(record)
            }
            
            try context.save()
            print("LOG: Запись для трекера с ID \(id) на дату \(startOfDay) удалена.")
            
        } catch {
            print("LOG: Ошибка при удалении записи: \(error.localizedDescription)")
        }
    }
    
    func hasRecord(trackerID: UUID, date: Date) -> Bool {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", trackerID as CVarArg, startOfDay as CVarArg)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("LOG: Ошибка при проверке записи: \(error.localizedDescription)")
            return false
        }
    }
    
    func toggleRecord(_ record: TrackerRecordModel) {
        if self.hasRecord(trackerID: record.trackerID, date: record.date) {
            self.removeRecord(byTrackerId: record.trackerID, date: record.date)
        } else {
            self.addRecord(record)
        }
    }
    
    func countRecords(for trackerID: UUID) -> Int {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@", trackerID as CVarArg)
        request.resultType = .countResultType
        
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("LOG: Ошибка при подсчёте записей: \(error.localizedDescription)")
            return 0
        }
    }
}

//
//
//    // Подсчет количества записей для указанного ID трекера
//    func countRecords(for trackerID: UUID) -> Int {
//        var count = 0
//        count = completedTrackers.filter { $0.trackerID == trackerID }.count
//
//        return count
//    }
//
//    // Добавление или удаление записи
//    func toggleRecord(_ record: TrackerRecordModel) {
//        if self.hasRecord(trackerID: record.trackerID, date: record.date) {
//            self.completedTrackers.remove(record)
//        } else {
//            self.completedTrackers.insert(record)
//        }
//    }
//}
