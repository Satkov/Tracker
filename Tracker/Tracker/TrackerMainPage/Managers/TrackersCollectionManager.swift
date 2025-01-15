import UIKit

final class TrackersCollectionManager: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let params: GeometricParamsModel
    private var categories: [TrackerCategoryModel] = []
    private let categoryManager = TrackerCategoryManager.shared
    private let datePicker: UIDatePicker
    private let recordManager = RecordManager.shared

    // MARK: - Initializer
    init(collectionView: UICollectionView, params: GeometricParamsModel, datePicker: UIDatePicker) {
        self.collectionView = collectionView
        self.params = params
        self.categories = categoryManager.getCategories(for: Schedule.dayOfWeek(for: datePicker.date))
        self.datePicker = datePicker
        super.init()
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

    private func handleButtonAction(at indexPath: IndexPath) {
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        recordManager.toggleRecord(TrackerRecordModel(trackerID: tracker.id, date: datePicker.date))
        collectionView.reloadItems(at: [indexPath])
    }

    func updateCategories() {
        categories = categoryManager.getCategories(for: Schedule.dayOfWeek(for: datePicker.date))
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersCollectionManager: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersCollectionManager: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackersCollectionCell",
            for: indexPath
        ) as? TrackersCollectionCell else {
            fatalError("Failed to dequeue TrackersCollectionCell")
        }
        let currentTracker = categories[indexPath.section].trackers[indexPath.row]
        let buttonAction = { [weak self] in
            guard let self = self else { return }
            self.handleButtonAction(at: indexPath)
        }
        cell.configure(with: currentTracker, buttonAction: buttonAction, datePicker: datePicker)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath
        ) as? SupplementaryView else {
            fatalError("Failed to dequeue SupplementaryView")
        }

        view.titleLabel.text = categories[indexPath.section].categoryName
        return view
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersCollectionManager: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: params.cellWidth, height: params.cellHeight)
    }
}
