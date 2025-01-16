import Foundation

enum Schedule: String, CaseIterable, Codable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"

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

    func shortName() -> String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }

    static var sortedOrder: [Schedule] {
        return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }

    static func formattedString(from days: Set<Schedule>) -> String {
        if days.count == 7 {
            return "Каждый день"
        }
        let sortedDays = days.sorted {
            sortedOrder.firstIndex(of: $0)! < sortedOrder.firstIndex(of: $1)!
        }
        return sortedDays.map { $0.shortName() }.joined(separator: ", ")
    }
}
