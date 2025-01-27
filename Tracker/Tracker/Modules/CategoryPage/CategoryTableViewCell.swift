import UIKit

final class CategoryTableViewCell: UITableViewCell {

    // MARK: - UI Elements
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.projectColor(.backgroundLightGray)
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let customAccessoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        let checkmark = UIImageView(image: UIImage(named: "checkmark"))
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkmark)

        NSLayoutConstraint.activate([
            checkmark.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkmark.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.isHidden = true
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

    // MARK: - Setup UI
    private func setupUI() {
        contentView.insertSubview(customBackgroundView, at: 0)
        contentView.addSubview(customAccessoryView)
        setupConstraints()
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background constraints
            customBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            customBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            // Accessory View constraints
            customAccessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customAccessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customAccessoryView.widthAnchor.constraint(equalToConstant: 20),
            customAccessoryView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    // MARK: - Public Methods
    func configureCell(with text: String, isSelected: Bool, isLast: Bool, isFirst: Bool) {
        textLabel?.text = text
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        customAccessoryView.isHidden = !isSelected

        setupCornerRadius(isFirst: isFirst, isLast: isLast)
    }

    func setAccessoryType(_ type: UITableViewCell.AccessoryType) {
        customAccessoryView.isHidden = (type != .checkmark)
    }

    // MARK: - Private Methods
    private func setupCornerRadius(isFirst: Bool, isLast: Bool) {
        customBackgroundView.layer.cornerRadius = 16

        switch (isFirst, isLast) {
        case (true, true):
            customBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case (true, false):
            customBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case (false, true):
            customBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default:
            customBackgroundView.layer.cornerRadius = 0
        }
    }
}
