import UIKit

final class TrackersCollectionPresenter: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let params: GeometricParamsModel
    private let datePicker: UIDatePicker
    private weak var delegate: TrackersCollectionPresenterDelegate?
    private lazy var trackersDataProvider: TrackersDataProvider = {
        try! TrackersDataProvider(TrackerDataStore(), delegate: self)
    }()

    private var currentDate: Date {
        datePicker.date
    }
    private var filter = FilterSettings(date: Date(),
                                             trackerName: "",
                                             recorded: .all)

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
    
    var hasTrackers: Bool {
        return trackersDataProvider.numberOfSections > 0
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        updateDate(sender.date)
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
        
        
        let currentCategoryName = trackersDataProvider.getCategoryNameForTrackerBy(id: currentTracker.id)
        guard let currentCategoryName = currentCategoryName else { return cell }
        let currentCategory = TrackerCategoryModel(categoryName: currentCategoryName)

        cell.configure(with: currentTracker, datePicker: datePicker)
        cell.onDelete = { [weak self] in
            try? self?.trackersDataProvider.deleteTracker(at: indexPath)
        }
        cell.onPinToggle = { [weak self] in
            self?.trackersDataProvider.togglePinTracker(for: currentTracker)
        }
        cell.onEdit = { [weak self] in
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
                editedTrackerData: dataForEdit
            )
            print(currentTracker.id, "ID" )
            print(currentTracker.isPinned, "pin")
            self?.delegate?.presentEditTrackerPage(vc: vc)
        }
        
        return cell
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
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
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
            delegate.updateUI()
        }
    }
}
