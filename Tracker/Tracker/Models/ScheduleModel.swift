import Foundation

enum Schedule: String, CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var localized: String {
        switch self {
        case .monday: return NSLocalizedString("monday", comment: "Понедельник")
        case .tuesday: return NSLocalizedString("tuesday", comment: "Вторник")
        case .wednesday: return NSLocalizedString("wednesday", comment: "Среда")
        case .thursday: return NSLocalizedString("thursday", comment: "Четверг")
        case .friday: return NSLocalizedString("friday", comment: "Пятница")
        case .saturday: return NSLocalizedString("saturday", comment: "Суббота")
        case .sunday: return NSLocalizedString("sunday", comment: "Воскресенье")
        }
    }

    var shortName: String {
        switch self {
        case .monday: return NSLocalizedString("monday.short", comment: "Пн")
        case .tuesday: return NSLocalizedString("tuesday.short", comment: "Вт")
        case .wednesday: return NSLocalizedString("wednesday.short", comment: "Ср")
        case .thursday: return NSLocalizedString("thursday.short", comment: "Чт")
        case .friday: return NSLocalizedString("friday.short", comment: "Пт")
        case .saturday: return NSLocalizedString("saturday.short", comment: "Сб")
        case .sunday: return NSLocalizedString("sunday.short", comment: "Вс")
        }
    }

    static func dayOfWeek(for date: Date) -> Schedule {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return getDayByNumberWeekday(weekday)
    }

    static func getDayByNumberWeekday(_ weekday: Int) -> Schedule {
        switch weekday {
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        case 1: return .sunday
        default: return .monday // По умолчанию
        }
    }

    static let sortedOrder: [Schedule] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

    static func formattedString(from days: Set<Schedule>) -> String {
        if days.count == 7 {
            return NSLocalizedString("everyDay", comment: "Каждый день")
        }
        let sortedDays = days.sorted {
            sortedOrder.firstIndex(of: $0)! < sortedOrder.firstIndex(of: $1)!
        }
        return sortedDays.map { $0.shortName }.joined(separator: ", ")
    }
}
