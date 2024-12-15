import UIKit

class CategoryTableViewCell: UITableViewCell {

    // MARK: - Properties
    private let customAccessoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        let checkmark = UIImageView(image: UIImage(named: "checkmark"))

        checkmark.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkmark)

        NSLayoutConstraint.activate([
            checkmark.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: 20),
            view.heightAnchor.constraint(equalToConstant: 20)
        ])
        view.isHidden = true // Скрываем галочку по умолчанию
        return view
    }()

    private let customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.projectColor(.backgroundLightGray)
        view.layer.masksToBounds = true
        return view
    }()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        // Используем customBackgroundView для закругления
        contentView.insertSubview(customBackgroundView, at: 0)
        contentView.addSubview(customAccessoryView)

        customBackgroundView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            customAccessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customAccessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: - Public Methods
    func configureCell(with text: String, isSelected: Bool, isLast: Bool) {
        textLabel?.text = text
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        // Показываем или скрываем кастомную галочку
        customAccessoryView.isHidden = !isSelected

        // Настраиваем закругленные углы
        if isLast {
            customBackgroundView.layer.cornerRadius = 16
            customBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            customBackgroundView.layer.cornerRadius = 0
        }
    }

    /// Установка кастомного аксессуара вместо accessoryType
    func setAccessoryType(_ type: UITableViewCell.AccessoryType) {
        switch type {
        case .checkmark:
            customAccessoryView.isHidden = false
        default:
            customAccessoryView.isHidden = true
        }
    }
}
