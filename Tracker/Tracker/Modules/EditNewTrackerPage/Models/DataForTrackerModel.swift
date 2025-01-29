import Foundation

struct DataForTrackerModel {
    let id: UUID?
    let name: String?
    let category: TrackerCategoryModel?
    let color: TrackerColors?
    let emoji: Emojis?
    let schudule: Set<Schedule>?
    let isPinned: Bool?
    let isRegular: Bool?

    init(
        id: UUID? = nil,
        name: String? = nil,
        category: TrackerCategoryModel? = nil,
        color: TrackerColors? = nil,
        emoji: Emojis? = nil,
        schudule: Set<Schedule>? = nil,
        isPinned: Bool? = nil,
        isRegular: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.color = color
        self.emoji = emoji
        self.schudule = schudule
        self.isPinned = isPinned
        self.isRegular = isRegular
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
