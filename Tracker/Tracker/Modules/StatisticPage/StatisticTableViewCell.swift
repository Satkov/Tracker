import UIKit

final class StatisticTableViewCell: UITableViewCell {
    // TODO: доделать страницу статистики
    private let counter = {
        let label = UILabel()
        
        return label
    }()
    
    private let statisticNameLabel = {
        let label = UILabel()
        
        return label
    }()
    
    private var type: StatisticType?
    
    func configurate(type: StatisticType) {
        self.type = type
    }
}


enum StatisticType: String {
    case bestStreak = "statisticPage.bestStreak"
    case perfectDays = "statisticPage.perfectDays"
    case allTrackersFinished = "statisticPage.allTrackersFinished"
    case averageValue = "statisticPage.averageValue"

    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
