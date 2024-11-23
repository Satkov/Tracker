import Foundation

extension Date {
    /// Преобразует дату в строку формата `дд.мм.гг`
    func toShortDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: self)
    }
}