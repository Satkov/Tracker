import Foundation

final class RecordManager {
    static let shared = RecordManager()
    
    private var records: Set<TrackerRecordModel> = []
    
    private init() {}
    
    // Загрузка всех записей
    func loadRecords() -> [TrackerRecordModel] {
        var result: [TrackerRecordModel] = []
        result = Array(records)
        return result
    }
    
    // Добавление новой записи
    func addRecord(_ record: TrackerRecordModel) {
        self.records.insert(record)
    }
    
    // Удаление записи по ID трекера
    func removeRecord(byId id: UUID) {
        self.records = self.records.filter { $0.trackerID != id }
    }
    
    // Проверка наличия записи с указанным ID трекера и датой
    func hasRecord(trackerID: UUID, date: Date) -> Bool {
        var result = false
        result = records.contains { $0.trackerID == trackerID && Calendar.current.isDate($0.date, inSameDayAs: date) }
        return result
    }
    
    // Подсчет количества записей для указанного ID трекера
    func countRecords(for trackerID: UUID) -> Int {
        var count = 0
        count = records.filter { $0.trackerID == trackerID }.count
        
        return count
    }
    
    // Добавление или удаление записи
    func toggleRecord(_ record: TrackerRecordModel) {
        if self.hasRecord(trackerID: record.trackerID, date: record.date) {
            self.records.remove(record)
        } else {
            self.records.insert(record)
        }
    }
}
