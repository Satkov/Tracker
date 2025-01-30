import UIKit

final class EmojiCollectionViewManager: NSObject {
    // MARK: - Properties
    private let collectionView: UICollectionView
    private let params: GeometricParamsModel
    private let presenter: EditTrackerPresenterProtocol
    private var selectedIndexPath: IndexPath?
    private var selectedEmoji: Emojis?

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

    func setSelectedEmoji(_ emoji: Emojis?) {
        selectedEmoji = emoji
        if let emoji = emoji, let index = Emojis.allCases.firstIndex(of: emoji) {
            selectedIndexPath = IndexPath(item: index, section: 0)
        } else {
            selectedIndexPath = nil
        }

        collectionView.reloadData()

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
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "EmojiCollectionViewCell")
        collectionView.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
    }
}

// MARK: - UICollectionViewDelegate
extension EmojiCollectionViewManager: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.visibleCells.forEach {
            $0.contentView.backgroundColor = .clear
        }

        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.projectColor(.alwaysLightgray)
        }

        selectedIndexPath = indexPath
        selectedEmoji = Emojis.allCases[indexPath.row]

        presenter.updateEmoji(new: selectedEmoji)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .clear
        }

        presenter.updateEmoji(new: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension EmojiCollectionViewManager: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return Emojis.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "EmojiCollectionViewCell",
            for: indexPath
        ) as? EmojiCollectionViewCell else {
            fatalError("Failed to dequeue EmojiCollectionViewCell")
        }

        let emoji = Emojis.allCases[indexPath.item]
        cell.configure(with: emoji.rawValue)

        if emoji == selectedEmoji {
            cell.contentView.backgroundColor = UIColor.projectColor(.lightGray)
        } else {
            cell.contentView.backgroundColor = .clear
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

        view.titleLabel.text = Localization.emojiTitle
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EmojiCollectionViewManager: UICollectionViewDelegateFlowLayout {
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
