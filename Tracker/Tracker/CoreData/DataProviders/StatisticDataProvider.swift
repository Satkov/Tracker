import Foundation

class StatisticDataProvider {
    let dataStore = StatisticDataStore()

    func getStatistic(type: StatisticType) -> String {
        switch type {
        case .allTrackersFinished:
            return dataStore.getTotalRecordsCount() ?? "0"
        case .bestStreak:
            return dataStore.getMaxRecordsPerTracker() ?? "0"
        case .averageValue:
            return dataStore.getAverageRecordsPerDay() ?? "0"
        }
    }

    func isDataExist() -> Bool {
        return dataStore.getTotalRecordsCount() != nil ||
               dataStore.getMaxRecordsPerTracker() != nil ||
               dataStore.getAverageRecordsPerDay() != nil
    }
}
