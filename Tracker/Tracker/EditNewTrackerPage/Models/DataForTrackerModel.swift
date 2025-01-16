import Foundation

struct DataForTrackerModel {
    // в данном случае переменные здесь для того, чтобы было
    // удобнее работать с EditNewTrackerPresenter. такой подход не стоит применять?
    var name: String?
    var category: TrackerCategoryModel?
    var color: TrackerColors?
    var emoji: Emojis?
    var schudule: Set<Schedule>?

    func isAllDataPresented(isRegular: Bool) -> Bool {
        let commonDataIsValid = category != nil && color != nil && emoji != nil && name != nil
        if isRegular {
            return commonDataIsValid && schudule != nil
        } else {
            return commonDataIsValid
        }
    }
}
