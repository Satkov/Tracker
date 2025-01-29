import UIKit

final class FilterButtonsTableViewCell: UITableViewCell {
    // MARK: - UI Elements
    private let labelsContainer = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.projectColor(.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(labelsContainer)
        labelsContainer.addSubview(titleLabel)
        contentView.addSubview(customAccessoryView)
        contentView.backgroundColor = UIColor.projectColor(.lightGray)
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Labels container
            labelsContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsContainer.trailingAnchor.constraint(lessThanOrEqualTo: customAccessoryView.leadingAnchor, constant: -8),

            // Title label
            titleLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),

            // customAccessoryView
            customAccessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            customAccessoryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customAccessoryView.widthAnchor.constraint(equalToConstant: 8),
            customAccessoryView.heightAnchor.constraint(equalToConstant: 13)
        ])
    }

    // MARK: - Configuration
    func configureButton(title: String, isSelected: Bool) {
        titleLabel.text = title
        
        customAccessoryView.isHidden = !isSelected
    }
}
