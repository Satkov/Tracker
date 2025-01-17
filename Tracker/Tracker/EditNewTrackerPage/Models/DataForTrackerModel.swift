import Foundation

struct DataForTrackerModel {
    let name: String?
    let category: TrackerCategoryModel?
    let color: TrackerColors?
    let emoji: Emojis?
    let schudule: Set<Schedule>?

    init(
        name: String? = nil,
        category: TrackerCategoryModel? = nil,
        color: TrackerColors? = nil,
        emoji: Emojis? = nil,
        schudule: Set<Schedule>? = nil
    ) {
        self.name = name
        self.category = category
        self.color = color
        self.emoji = emoji
        self.schudule = schudule
    }

    func isAllDataPresented(isRegular: Bool) -> Bool {
        let commonDataIsValid = category != nil && color != nil && emoji != nil && name != nil
        if isRegular {
            return commonDataIsValid && schudule != nil
        } else {
            return commonDataIsValid
        }
    }
}

