import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        return label
    }()

    var emojiBackGroundColor: UIColor {
        didSet {
            emojiLabel.backgroundColor = emojiBackGroundColor
        }
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        emojiBackGroundColor = .clear
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with emoji: String) {
        emojiLabel.text = emoji
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 32),
            emojiLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
}
