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
    case bestStreak = "Лучший период"
    case perfectDays = "Идеальные дни"
    case allTrackersFinished = "Трекеров завершено"
    case averageValue = "Среднее значение"
}
