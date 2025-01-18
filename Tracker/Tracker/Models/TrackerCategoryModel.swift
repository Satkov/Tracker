struct TrackerCategoryModel {
    let categoryName: String
    let trackers: [TrackerModel]

    init(categoryName: String, trackers: [TrackerModel] = []) {
        self.categoryName = categoryName
        self.trackers = trackers
    }
}
