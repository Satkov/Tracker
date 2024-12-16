import Foundation

struct DataForTrackerModel {
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
