import Foundation
import UIKit

struct TrackerModel {
    let id = UUID()
    let name: String
    let color: TrackerColors
    let emoji: Emojis
    let schedule: [Schedule]?
}

enum TrackerColors: String, CaseIterable {
    case red = "0xFD4C49" // Красный
    case orange = "0xFF881E" // Оранжевый
    case blue = "0x007BFA" // Синий
    case purple = "0x6E44FE" // Фиолетовый
    case green = "0x33CF69" // Зелёный
    case pink = "0xE66DD4" // Розовый
    case peach = "0xF9D4D4" // Персиковый
    case skyBlue = "0x34A7FE" // Небесно-голубой
    case mint = "0x46E69D" // Мятный
    case navy = "0x35347C" // Тёмно-синий
    case coral = "0xFF674D" // Коралловый
    case softPink = "0xFF99CC" // Нежно-розовый
    case beige = "0xF6C48B" // Бежевый
    case lavender = "0x7994F5" // Лавандовый
    case deepPurple = "0x832CF1" // Тёмно-фиолетовый
    case violet = "0xAD56DA" // Виолетовый
    case teal = "0x8D72E6" // Бирюзовый
    case salad = "0x2FD058" // Салатовый
    
    var color: UIColor {
        return UIColor(hex: self.rawValue)
    }
}

enum Schedule: String, CaseIterable {
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
        case 0: return .monday
        case 1: return .tuesday
        case 2: return .wednesday
        case 3: return .thursday
        case 4: return .friday
        case 5: return .saturday
        case 6: return .sunday
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
    
    static func formattedString(from days: [Schedule]) -> String {
        let sortedDays = days.sorted {
            sortedOrder.firstIndex(of: $0)! < sortedOrder.firstIndex(of: $1)!
        }
        return sortedDays.map { $0.shortName() }.joined(separator: ", ")
    }
}

enum Emojis: String, CaseIterable {
    case smilingFace = "🙂"
    case heartEyesCat = "😻"
    case hibiscus = "🌺"
    case dogFace = "🐶"
    case redHeart = "❤️"
    case screamingFace = "😱"
    case smilingFaceWithHalo = "😇"
    case angryFace = "😡"
    case coldFace = "🥶"
    case thinkingFace = "🤔"
    case raisingHands = "🙌"
    case hamburger = "🍔"
    case broccoli = "🥦"
    case pingPong = "🏓"
    case firstPlaceMedal = "🥇"
    case guitar = "🎸"
    case desertIsland = "🏝"
    case sleepyFace = "😪"
}

