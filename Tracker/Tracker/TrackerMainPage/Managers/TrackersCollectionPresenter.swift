import UIKit

final class TrackersCollectionPresenter: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let params: GeometricParamsModel
    private let datePicker: UIDatePicker
    private let recordManager = RecordManager()
    private lazy var dataProvider: TrackersDataProvider = {
        try! TrackersDataProvider(TrackerDataStore(), delegate: self)
    }()

    private var currentDate: Date {
        datePicker.date
    }

    // MARK: - Initializer
    init(collectionView: UICollectionView, params: GeometricParamsModel, datePicker: UIDatePicker) throws {
        self.collectionView = collectionView
        self.params = params
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

    // MARK: - Actions
    private func handleButtonAction(at indexPath: IndexPath) {
        guard currentDate <= Date() else { return }
        if let tracker = dataProvider.trackerObject(at: indexPath) {
            recordManager.toggleRecord(TrackerRecordModel(trackerID: tracker.id, date: currentDate))
            collectionView.reloadItems(at: [indexPath])
        }
    }

    // MARK: - Public Methods
    func updateCategories() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersCollectionPresenter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfRowsInSection(section) // ✅ Теперь данные из DataProvider
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TrackersCollectionCell",
            for: indexPath
        ) as? TrackersCollectionCell else {
            fatalError("Failed to dequeue TrackersCollectionCell")
        }

        guard let currentTracker = dataProvider.trackerObject(at: indexPath) else {
            return cell
        }

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
        let sectionName = dataProvider.sectionName(for: indexPath.section)
        view.titleLabel.text = sectionName
        return view
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataProvider.numberOfSections
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersCollectionPresenter: UICollectionViewDelegateFlowLayout {
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

// MARK: - TrackersDataProviderDelegate
extension TrackersCollectionPresenter: DataProviderDelegate {
    func didUpdate(_ update: StoreUpdate) {
        collectionView.performBatchUpdates {
            var insertedIndexPaths: [IndexPath] = []
            var deletedIndexPaths: [IndexPath] = []

            // ✅ Вставка и удаление секций
            let insertedSections = IndexSet(update.insertedSections)
            let deletedSections = IndexSet(update.deletedSections)

            if !insertedSections.isEmpty {
                collectionView.insertSections(insertedSections)
            }
            if !deletedSections.isEmpty {
                collectionView.deleteSections(deletedSections)
            }

            // ✅ Вставка элементов с правильными секциями
            for index in update.insertedIndexes {
                let section = findSection(for: index)
                let indexPath = IndexPath(item: index, section: section)
                insertedIndexPaths.append(indexPath)
            }

            // ✅ Удаление элементов с правильными секциями
            for index in update.deletedIndexes {
                let section = findSection(for: index)
                let indexPath = IndexPath(item: index, section: section)
                deletedIndexPaths.append(indexPath)
            }

            if !insertedIndexPaths.isEmpty {
                collectionView.insertItems(at: insertedIndexPaths)
            }
            if !deletedIndexPaths.isEmpty {
                collectionView.deleteItems(at: deletedIndexPaths)
            }
        } completion: { _ in
            self.collectionView.reloadData() // ✅ Гарантируем, что всё обновилось корректно
        }
    }

    // 📌 Метод для определения секции элемента
    private func findSection(for index: Int) -> Int {
        for section in 0..<dataProvider.numberOfSections {
            if index < dataProvider.numberOfRowsInSection(section) {
                return section
            }
        }
        return 0 // Фоллбек (не должен срабатывать)
    }
}
