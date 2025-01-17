import Foundation

final class RecordManager {
    static let shared = RecordManager()

    private var completedTrackers: Set<TrackerRecordModel> = []

    private init() {}

    // Загрузка всех записей
    func loadRecords() -> [TrackerRecordModel] {
        var result: [TrackerRecordModel] = []
        result = Array(completedTrackers)
        return result
    }

    // Добавление новой записи
    func addRecord(_ record: TrackerRecordModel) {
        self.completedTrackers.insert(record)
    }

    // Удаление записи по ID трекера
    func removeRecord(byId id: UUID) {
        self.completedTrackers = self.completedTrackers.filter { $0.trackerID != id }
    }

    // Проверка наличия записи с указанным ID трекера и датой
    func hasRecord(trackerID: UUID, date: Date) -> Bool {
        var result = false
        result = completedTrackers.contains { $0.trackerID == trackerID && Calendar.current.isDate($0.date, inSameDayAs: date) }
        return result
    }

    // Подсчет количества записей для указанного ID трекера
    func countRecords(for trackerID: UUID) -> Int {
        var count = 0
        count = completedTrackers.filter { $0.trackerID == trackerID }.count

        return count
    }

    // Добавление или удаление записи
    func toggleRecord(_ record: TrackerRecordModel) {
        if self.hasRecord(trackerID: record.trackerID, date: record.date) {
            self.completedTrackers.remove(record)
        } else {
            self.completedTrackers.insert(record)
        }
    }
}
