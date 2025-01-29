import UIKit

final class TrackersCollectionPresenter: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let params: GeometricParamsModel
    private weak var delegate: TrackersCollectionPresenterDelegate?
    private lazy var trackersDataProvider: TrackersDataProvider = {
        try! TrackersDataProvider(TrackerDataStore(), delegate: self)
    }()
    private let datePicker: UIDatePicker
    var currentDate: Date {
        Calendar.current.startOfDay(for: datePicker.date)
    }
    private var filter = FilterSettings(date: Date(),
                                        trackerName: "",
                                        recorded: .all)
    private var filterButtonIsHidden: Bool?
    
    // MARK: - Initializer
    init(collectionView: UICollectionView, 
         params: GeometricParamsModel,
         datePicker: UIDatePicker,
         delegate: TrackersCollectionPresenterDelegate?
    ) throws {
        self.collectionView = collectionView
        self.params = params
        self.datePicker = datePicker
        self.delegate = delegate
        super.init()
        self.trackersDataProvider.filterTrackers(filters: filter)
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        configureCollectionView()
        filterButtonIsHidden = false
    }

    // MARK: - Configuration
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackersCollectionCell.self, forCellWithReuseIdentifier: "TrackersCollectionCell")
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
    }

    // MARK: - Actions
    func updateDate(_ newDate: Date) {
        filter.date = newDate
        trackersDataProvider.filterTrackers(filters: filter)
    }
    
    func searchBarTextUpdated(text: String) {
        filter.trackerName = text
        trackersDataProvider.filterTrackers(filters: filter)
    }
    
    var isFilteredTrackersHaveTrackers: Bool {
        return trackersDataProvider.numberOfSections > 0
    }
    
    // метод нужен чтобы фильтр не пропадал, если после фильтрации не осталось трекеров
    func isAnyTrackersForChoosenDateExist(_ date: Date) -> Bool {
        return trackersDataProvider.isAnyTrackersForChoosenDateExist(date)
    }
    
    func applyFilters(_ newFilter: FilterChoice) {
        switch newFilter {
        case .all:
            filter.recorded = .all
        case .recorded:
            filter.recorded = .onlyRecorded
        case .unrecorded:
            filter.recorded = .onlyUnRecorded
        case .today:
            datePicker.date = Date()
            filter = FilterSettings(
                date: Date(),
                trackerName: filter.trackerName,
                recorded: .all
            )
        }
        trackersDataProvider.filterTrackers(filters: filter)
    }
    
    private func showDeleteConfirmation(at indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: nil,
            message: "Уверены, что хотите удалить трекер?",
            preferredStyle: .actionSheet
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            try? self?.trackersDataProvider.deleteTracker(at: indexPath)
        }

        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        delegate?.present(alertController, animated: true)
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        updateDate(sender.date)
    }
}

extension TrackersCollectionPresenter: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard filterButtonIsHidden != nil else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY + frameHeight >= contentHeight && contentHeight != 0{
            FilterButtonManager.shared.removeFilterButton()
        } else {
            FilterButtonManager.shared.showFilterButton()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersCollectionPresenter: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return trackersDataProvider.numberOfRowsInSection(section)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackersCollectionCell",
            for: indexPath
        ) as? TrackersCollectionCell else {
            fatalError("Failed to dequeue TrackersCollectionCell")
        }

        guard let currentTracker = trackersDataProvider.trackerObject(at: indexPath) else {
            return cell
        }

        cell.configure(with: currentTracker, datePicker: datePicker)
        cell.onDelete = { [weak self] in
            AnalyticsService.shared.logEvent(
                event: "delete_context_menu_button_tapped",
                screen: "main_screen",
                item: "edit_context_menu_button"
            )
            self?.showDeleteConfirmation(at: indexPath)
        }
        cell.onPinToggle = { [weak self] in
            self?.trackersDataProvider.togglePinTracker(for: currentTracker)
        }
        
        let recordsDataStore = RecordsDataStore()
        let recordsCount = recordsDataStore.countRecords(for: currentTracker.id)
        
        let currentCategoryName = trackersDataProvider.getCategoryNameForTrackerBy(id: currentTracker.id)
        guard let currentCategoryName = currentCategoryName else { return cell }
        let currentCategory = TrackerCategoryModel(categoryName: currentCategoryName)
        
        cell.onEdit = { [weak self] in
            AnalyticsService.shared.logEvent(
                event: "edit_context_menu_button_tapped",
                screen: "main_screen",
                item: "edit_context_menu_button"
            )
            
            let dataForEdit = DataForTrackerModel(
                id: currentTracker.id,
                name: currentTracker.name,
                category: currentCategory,
                color: currentTracker.color,
                emoji: currentTracker.emoji,
                schudule: currentTracker.schedule,
                isPinned: currentTracker.isPinned,
                isRegular: currentTracker.isRegular
            )
            
            let vc = EditTrackerViewController(
                type: currentTracker.isRegular,
                presenter: EditNewTrackerPresenter(),
                editedTrackerData: dataForEdit,
                recordsCount: recordsCount
            )
            self?.delegate?.presentEditTrackerPage(vc: vc)
        }
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let selectedTracker = trackersDataProvider.trackerObject(at: indexPath) else { return }
        
        AnalyticsService.shared.logEvent(
            event: "cell_tap",
            screen: "trackers_list",
            item: selectedTracker.name
        )
        
        print("Выбрана ячейка: \(selectedTracker.name)")
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath
        ) as? SupplementaryView else {
            fatalError("Failed to dequeue SupplementaryView")
        }
        let sectionName = trackersDataProvider.sectionName(for: indexPath.section)
        view.titleLabel.text = sectionName
        return view
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return trackersDataProvider.numberOfSections
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersCollectionPresenter: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: collectionView.frame.width, height: 19)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if trackersDataProvider.numberOfSections - 1 == section {
            return UIEdgeInsets(top: 12, left: params.leftInset, bottom: 50, right: params.rightInset)
        }
        return UIEdgeInsets(top: 12, left: params.leftInset, bottom: 0, right: params.rightInset)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return params.cellSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: params.cellWidth, height: params.cellHeight)
    }
}

// MARK: - TrackersDataProviderDelegate
extension TrackersCollectionPresenter: DataProviderDelegate {
    func didUpdate() {
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            guard let delegate = self.delegate else {
                return
            }
            delegate.updateUI(date: self.currentDate)
        }
    }
}
