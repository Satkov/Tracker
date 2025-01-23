import UIKit

final class ColorCollectionManager: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let params: GeometricParamsModel
    private let presenter: EditNewTrackerPresenterProtocol

    // MARK: - Initializer
    init(
        collectionView: UICollectionView,
        params: GeometricParamsModel,
        presenter: EditNewTrackerPresenterProtocol
    ) {
        self.collectionView = collectionView
        self.params = params
        self.presenter = presenter
        super.init()
        configureCollectionView()
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
        }

        presenter.updateColor(new: TrackerColors.allCases[indexPath.row])
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }

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

        cell.cellColor = TrackerColors.allCases[indexPath.item].getUIColor()
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

        view.titleLabel.text = "Цвет"
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
