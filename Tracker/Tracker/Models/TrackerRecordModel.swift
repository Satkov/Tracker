import Foundation

struct TrackerRecordModel: Codable, Hashable {
    let trackerID: UUID
    let date: Date

    init(trackerID: UUID, date: Date) {
        self.trackerID = trackerID
        // Обнуляем время потому что иначе отметка о выполнении не будет удаляться,
        // из-за разницы в секундах
        self.date = Calendar.current.startOfDay(for: date)
    }
}
