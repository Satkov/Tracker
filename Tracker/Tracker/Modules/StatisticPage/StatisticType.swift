import Foundation

enum StatisticType: String, CaseIterable {
    case bestStreak = "statisticPage.bestStreak"
    case allTrackersFinished = "statisticPage.allTrackersFinished"
    case averageValue = "statisticPage.averageValue"

    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
