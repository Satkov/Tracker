import UIKit

final class EditNewTrackerPresenter: EditNewTrackerPresenterProtocol {
    private weak var view: EditNewTrackerViewControllerProtocol?
    var onTrackerCreation: (() -> Void)?
    private(set) var dataModel = DataForTrackerModel() {
        didSet {
            // TODO: обработка ошибки если вью не предоставлена
            guard let view else { return }
            if dataModel.isAllDataPresented(isRegular: view.isRegular) {
                view.setCreateButtonEnable()
            } else {
                view.setCreateButtonDissable()
            }
        }
    }
    
    func configure(view: EditNewTrackerViewControllerProtocol) {
        self.view = view
    }

    func updateName(name: String?) {
        dataModel.name = name
    }

    func updateSchedule(new: Set<Schedule>?) {
        view?.reloadButtonTable()
        dataModel.schudule = new
    }

    func updateCategory(new: TrackerCategoryModel?) {
        view?.reloadButtonTable()
        dataModel.category = new
    }

    func updateEmoji(new: Emojis?) {
        dataModel.emoji = new
    }

    func updateColor(new: TrackerColors?) {
        dataModel.color = new
    }

    func createTracker() -> TrackerModel? {
        guard let name = dataModel.name,
              let emoji = dataModel.emoji,
              let color = dataModel.color
        else { return nil }
        let tracker = TrackerModel(name: name,
                                   color: color,
                                   emoji: emoji,
                                   schedule: dataModel.schudule)
        return tracker
    }

    func saveTracker(tracker: TrackerModel?) {
        guard let tracker = tracker,
              let category = dataModel.category
        else {
            // TODO: Обработка ошибки
            return
        }
        let categoryManager = TrackerCategoryManager.shared
        categoryManager.addTracker(to: category.categoryName, tracker: tracker)
        onTrackerCreation?()
    }
}
