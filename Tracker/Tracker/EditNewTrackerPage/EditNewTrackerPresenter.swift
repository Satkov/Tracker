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
    
    private func updateDataModel(
        name: String? = nil,
        category: TrackerCategoryModel? = nil,
        color: TrackerColors? = nil,
        emoji: Emojis? = nil,
        schudule: Set<Schedule>? = nil
    ) {
        let updatedModel = DataForTrackerModel(
            name: name ?? dataModel.name,
            category: category ?? dataModel.category,
            color: color ?? dataModel.color,
            emoji: emoji ?? dataModel.emoji,
            schudule: schudule ?? dataModel.schudule
        )
        dataModel = updatedModel
    }
    
    func configure(view: EditNewTrackerViewControllerProtocol) {
        self.view = view
    }

    func updateName(name: String?) {
        updateDataModel(name: name)
    }

    func updateSchedule(new: Set<Schedule>?) {
        view?.reloadButtonTable()
        updateDataModel(schudule: new)
    }

    func updateCategory(new: TrackerCategoryModel?) {
        view?.reloadButtonTable()
        updateDataModel(category: new)
    }

    func updateEmoji(new: Emojis?) {
        updateDataModel(emoji: new)
    }

    func updateColor(new: TrackerColors?) {
        updateDataModel(color: new)
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
