import Foundation

final class StatisticDataProvider {
    let dataStore = StatisticDataStore()

    func getStatistic(type: StatisticType) -> String {
        switch type {
        case .allTrackersFinished:
            dataStore.getTotalRecordsCount() ?? "0"
        case .bestStreak:
            dataStore.getMaxRecordsPerTracker() ?? "0"
        case .averageValue:
            dataStore.getAverageRecordsPerDay() ?? "0"
        }
    }

    func isDataExist() -> Bool {
        return dataStore.getTotalRecordsCount() != nil ||
               dataStore.getMaxRecordsPerTracker() != nil ||
               dataStore.getAverageRecordsPerDay() != nil
    }
}
