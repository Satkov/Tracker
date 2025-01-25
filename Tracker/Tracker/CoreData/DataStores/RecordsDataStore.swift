import Foundation
import CoreData

final class RecordsDataStore {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }
    
    // MARK: - Toggle Record (Добавить или удалить запись)
    func toggleRecord(_ record: TrackerRecordModel) {
        if hasRecord(trackerID: record.trackerID, date: record.date) {
            removeRecord(byTrackerId: record.trackerID, date: record.date)
        } else {
            addRecord(record)
        }
    }
    
    // MARK: - Добавление записи
    private func addRecord(_ record: TrackerRecordModel) {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", record.trackerID as CVarArg)

        do {
            if let tracker = try context.fetch(request).first {
                let recordCoreData = RecordCoreData(context: context)
                recordCoreData.date = Calendar.current.startOfDay(for: record.date)
                recordCoreData.tracker = tracker
                
                try context.save()
            } else {
                // TODO: обработка ошибки
            }
        } catch {
            // TODO: обработка ошибки
        }
    }
    
    // MARK: - Удаление записи
    private func removeRecord(byTrackerId id: UUID, date: Date) {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", id as CVarArg, startOfDay as CVarArg)
        
        do {
            let recordsToDelete = try context.fetch(request)
            
            if recordsToDelete.isEmpty {
                // TODO: обработка ошибки
                return
            }
            
            for record in recordsToDelete {
                context.delete(record)
            }
            
            try context.save()
            
        } catch {
            // TODO: обработка ошибки
        }
    }
    
    // MARK: - Проверка наличия записи
    func hasRecord(trackerID: UUID, date: Date) -> Bool {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        let startOfDay = Calendar.current.startOfDay(for: date)
        
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date == %@", trackerID as CVarArg, startOfDay as CVarArg)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            // TODO: обработка ошибки
            return false
        }
    }
    
    // MARK: - Подсчет количества записей для трекера
    func countRecords(for trackerID: UUID) -> Int {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@", trackerID as CVarArg)
        request.resultType = .countResultType
        
        do {
            return try context.count(for: request)
        } catch {
            // TODO: обработка ошибки
            return 0
        }
    }
}
