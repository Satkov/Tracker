import UIKit

final class EditNewTrackerPresenter: EditTrackerPresenterProtocol {
    private weak var view: EditTrackerViewControllerProtocol?
    private var isNewTracker = true
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

    func configure(
        view: EditTrackerViewControllerProtocol,
        editedTrackerData: DataForTrackerModel?) {
            self.view = view
            if let editedTrackerData = editedTrackerData {
                isNewTracker = false
                self.dataModel = editedTrackerData
            }
            setIsReguler()
        }

    
    private func setIsReguler() {
        let updatedModel = DataForTrackerModel(
            id: dataModel.id,
            name: dataModel.name,
            category: dataModel.category,
            color: dataModel.color,
            emoji: dataModel.emoji,
            schudule: dataModel.schudule,
            isPinned: dataModel.isPinned,
            isRegular: view?.isRegular
        )
        dataModel = updatedModel
    }
    
    func updateName(name: String?) {

        let newName = name == "" ? nil : name

        let updatedModel = DataForTrackerModel(
            id: dataModel.id,
            name: newName,
            category: dataModel.category,
            color: dataModel.color,
            emoji: dataModel.emoji,
            schudule: dataModel.schudule,
            isPinned: dataModel.isPinned,
            isRegular: dataModel.isRegular
        )
        dataModel = updatedModel
    }

    func updateSchedule(new: Set<Schedule>?) {
        view?.reloadButtonTable()

        let newSchedule = new?.isEmpty == true ? nil : new

        dataModel = DataForTrackerModel(
            id: dataModel.id,
            name: dataModel.name,
            category: dataModel.category,
            color: dataModel.color,
            emoji: dataModel.emoji,
            schudule: newSchedule,
            isPinned: dataModel.isPinned,
            isRegular: dataModel.isRegular
        )
    }

    func updateCategory(new: TrackerCategoryModel?) {
        view?.reloadButtonTable()

        let updatedModel = DataForTrackerModel(
            id: dataModel.id,
            name: dataModel.name,
            category: new,
            color: dataModel.color,
            emoji: dataModel.emoji,
            schudule: dataModel.schudule,
            isPinned: dataModel.isPinned,
            isRegular: dataModel.isRegular
        )
        dataModel = updatedModel
    }

    func updateEmoji(new: Emojis?) {
        let updatedModel = DataForTrackerModel(
            id: dataModel.id,
            name: dataModel.name,
            category: dataModel.category,
            color: dataModel.color,
            emoji: new,
            schudule: dataModel.schudule,
            isPinned: dataModel.isPinned,
            isRegular: dataModel.isRegular
        )
        dataModel = updatedModel
    }

    func updateColor(new: TrackerColors?) {
        let updatedModel = DataForTrackerModel(
            id: dataModel.id,
            name: dataModel.name,
            category: dataModel.category,
            color: new,
            emoji: dataModel.emoji,
            schudule: dataModel.schudule,
            isPinned: dataModel.isPinned,
            isRegular: dataModel.isRegular
        )
        dataModel = updatedModel
    }

    func createTracker() -> TrackerModel? {
        guard let name = dataModel.name,
              let emoji = dataModel.emoji,
              let color = dataModel.color,
              let view = view
        else { return nil }
        
        let schedule = view.isRegular ? dataModel.schudule : Set(Schedule.allCases)
        
        
        let tracker = TrackerModel(id: dataModel.id ?? UUID(),
                                   name: name,
                                   color: color,
                                   emoji: emoji,
                                   schedule: schedule,
                                   isPinned: dataModel.isPinned ?? false,
                                   isRegular: view.isRegular)
        return tracker
    }

    func saveTracker(tracker: TrackerModel?) {
        guard let tracker = tracker,
              let category = dataModel.category
        else {
            // TODO: Обработка ошибки
            return
        }
        let trackerManager = TrackerDataStore()
        
        if isNewTracker {
            try? trackerManager.add(tracker: tracker, categoryName: category.categoryName)
        } else {
            try? trackerManager.updateTracker(tracker, in: category)
        }
    }
}
