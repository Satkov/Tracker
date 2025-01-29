import Foundation

protocol EditNewTrackerPresenterProtocol: AnyObject {
    func configure(
        view: EditNewTrackerViewControllerProtocol,
        editedTrackerData: DataForTrackerModel?
    )
    func updateName(name: String?)
    func updateSchedule(new: Set<Schedule>?)
    func updateCategory(new: TrackerCategoryModel?)
    func updateEmoji(new: Emojis?)
    func updateColor(new: TrackerColors?)
    func createTracker() -> TrackerModel?
    func saveTracker(tracker: TrackerModel?)
    var dataModel: DataForTrackerModel { get }
}
