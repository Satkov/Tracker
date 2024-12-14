struct TrackerCategoryModel: Codable {
    var categoryName: String
    var trackers: [TrackerModel]
    
    init(categoryName: String, trackers: [TrackerModel] = []) {
        self.categoryName = categoryName
        self.trackers = trackers
    }
}
