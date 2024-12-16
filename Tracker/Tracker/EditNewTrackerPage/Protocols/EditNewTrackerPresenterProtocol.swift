import Foundation

protocol EditNewTrackerPresenterProtocol {
    func updateName(name: String?)
    func updateSchedule(new: Set<Schedule>?)
    func updateCategory(new: TrackerCategoryModel?)
    func updateEmoji(new: Emojis?)
    func updateColor(new: TrackerColors?)
    func createTracker() -> TrackerModel?
    func saveTrackerInUserDefaults(tracker: TrackerModel?)
    var dataModel: DataForTrackerModel { get }
}
