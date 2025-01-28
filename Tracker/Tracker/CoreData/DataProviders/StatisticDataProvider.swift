import Foundation

class StatisticDataProvider {
    let dataStore = StatisticDataStore()
    
    func getStatistic(type: StatisticType) -> String {
        switch type {
        case .allTrackersFinished:
            return dataStore.getTotalRecordsCount()
        case .bestStreak:
            return dataStore.getMaxRecordsPerTracker()
        case .averageValue:
            return dataStore.getAverageRecordsPerDay()
        }
    }
}
