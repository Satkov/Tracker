import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        return label
    }()

    // MARK: - Properties
    private var emojiBackGroundColor: UIColor = .clear {
        didSet {
            emojiLabel.backgroundColor = emojiBackGroundColor
        }
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with emoji: String, backgroundColor: UIColor = .clear) {
        emojiLabel.text = emoji
        emojiBackGroundColor = backgroundColor
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.addSubview(emojiLabel)
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 32),
            emojiLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
}
