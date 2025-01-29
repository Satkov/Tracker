import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    static func projectColor(_ color: ProjectColors) -> UIColor {
        guard let color = UIColor(named: color.rawValue) else {
            // TODO: обработка ошибки
            return .red
        }
        return color
    }
}

enum ProjectColors: String {
    case gray = "TextColorForLightgray"
    case black = "TrackerBackgroundBlack"
    case lightGray = "TrackerBackgroundLightGray"
    case white = "TrackerBackgroundWhite"
    case blue = "TrackerBlue"
    case darkGray = "TrackerGray"
    case borderRed = "ButtonBorderRed"
    case alwaysblack = "alwaysBlack"
    case alwaysWhite = "alwaysWhite"
}
