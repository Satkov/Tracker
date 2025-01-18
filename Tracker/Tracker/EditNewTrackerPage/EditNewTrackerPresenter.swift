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

    
    // я не смог придумать как это по-человечести сделать красиво, чтобы константы оставить в модельке
    // чтобы при этом не ломалась логика карточки редактирования трекера.
    func updateName(name: String?) {
        
        let newName = name == "" ? nil : name
        
        let updatedModel = DataForTrackerModel(
            name: newName,
            category: dataModel.category,
            color: dataModel.color,
            emoji: dataModel.emoji,
            schudule: dataModel.schudule
        )
        dataModel = updatedModel
    }

    func updateSchedule(new: Set<Schedule>?) {
        view?.reloadButtonTable()
        
        let newSchedule = new?.isEmpty == true ? nil : new
        
        dataModel = DataForTrackerModel(
            name: dataModel.name,
            category: dataModel.category,
            color: dataModel.color,
            emoji: dataModel.emoji,
            schudule: newSchedule
        )
    }

    func updateCategory(new: TrackerCategoryModel?) {
        view?.reloadButtonTable()
        
        let updatedModel = DataForTrackerModel(
            name: dataModel.name,
            category: new,
            color: dataModel.color,
            emoji: dataModel.emoji,
            schudule: dataModel.schudule
        )
        dataModel = updatedModel
    }

    func updateEmoji(new: Emojis?) {
        let updatedModel = DataForTrackerModel(
            name: dataModel.name,
            category: dataModel.category,
            color: dataModel.color,
            emoji: new,
            schudule: dataModel.schudule
        )
        dataModel = updatedModel
    }

    func updateColor(new: TrackerColors?) {
        let updatedModel = DataForTrackerModel(
            name: dataModel.name,
            category: dataModel.category,
            color: new,
            emoji: dataModel.emoji,
            schudule: dataModel.schudule
        )
        dataModel = updatedModel
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
