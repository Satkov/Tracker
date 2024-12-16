import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    let emojiLabel  = UILabel()
    var emojiBackGroundColor: UIColor {
        didSet {
            emojiLabel.backgroundColor = emojiBackGroundColor
        }
    }

    override init(frame: CGRect) {
        emojiBackGroundColor = .clear
        super.init(frame: frame)

        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .center
        contentView.layer.cornerRadius = 16

        contentView.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 32),
            emojiLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with emoji: String) {
            emojiLabel.text = emoji
        }
}
