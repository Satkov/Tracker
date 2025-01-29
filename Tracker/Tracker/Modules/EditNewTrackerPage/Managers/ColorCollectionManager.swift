import UIKit

final class ColorCollectionManager: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let params: GeometricParamsModel
    private let presenter: EditTrackerPresenterProtocol
    private var selectedColor: TrackerColors?
    private var selectedIndexPath: IndexPath?

    // MARK: - Initializer
    init(
        collectionView: UICollectionView,
        params: GeometricParamsModel,
        presenter: EditTrackerPresenterProtocol
    ) {
        self.collectionView = collectionView
        self.params = params
        self.presenter = presenter
        super.init()
        configureCollectionView()
    }

    // MARK: - Public Methods
    func setSelectedColor(_ color: TrackerColors?) {
        selectedColor = color
        
        if let color = color, let index = TrackerColors.allCases.firstIndex(of: color) {
            selectedIndexPath = IndexPath(item: index, section: 0)
        } else {
            selectedIndexPath = nil
        }
        
        collectionView.reloadData()
        
        // ✅ Выделяем ячейку после обновления данных
        if let selectedIndexPath = selectedIndexPath {
            collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
        }
    }

    // MARK: - Configuration
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: "ColorCollectionViewCell"
        )
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
    }
}

// MARK: - UICollectionViewDelegate
extension ColorCollectionManager: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.visibleCells.forEach { cell in
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }

        if let cell = collectionView.cellForItem(at: indexPath) {
            let color = TrackerColors.allCases[indexPath.row].getUIColor()
            cell.contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            cell.contentView.layer.borderWidth = 3.0
        }

        selectedIndexPath = indexPath
        selectedColor = TrackerColors.allCases[indexPath.row]
        
        presenter.updateColor(new: selectedColor)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }

        selectedIndexPath = nil
        selectedColor = nil
        presenter.updateColor(new: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension ColorCollectionManager: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return TrackerColors.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ColorCollectionViewCell", for: indexPath
        ) as? ColorCollectionViewCell else {
            fatalError("Failed to dequeue ColorCollectionViewCell")
        }

        let color = TrackerColors.allCases[indexPath.item].getUIColor()
        cell.cellColor = color

        // ✅ Выделяем ячейку, если цвет совпадает
        if selectedColor == TrackerColors.allCases[indexPath.item] {
            cell.contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            cell.contentView.layer.borderWidth = 3.0
        } else {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 0
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

        view.titleLabel.text = Localization.colorTitle
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ColorCollectionManager: UICollectionViewDelegateFlowLayout {
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
        UIEdgeInsets(
            top: 24,
            left: params.leftInset,
            bottom: 0,
            right: params.rightInset
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        params.cellSpacing
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: params.cellWidth, height: params.cellHeight)
    }
}
