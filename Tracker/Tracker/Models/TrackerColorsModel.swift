import UIKit

enum TrackerColors: String, CaseIterable, Codable {
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

    func getUIColor() -> UIColor {
        return UIColor(hex: self.rawValue)
    }
}
