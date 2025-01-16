import UIKit

final class ButtonsTableViewCells: UITableViewCell {
    // MARK: - UI Elements
    private let labelsContainer = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.projectColor(.backgroundBlack)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.projectColor(.textColorForLightgray)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        labelsContainer.addSubview(subtitleLabel)
        contentView.addSubview(arrowImageView)
        contentView.backgroundColor = UIColor.projectColor(.backgroundLightGray)
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Labels container
            labelsContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelsContainer.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -8),

            // Title label
            titleLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),

            // Subtitle label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor),

            // Arrow image
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 8),
            arrowImageView.heightAnchor.constraint(equalToConstant: 13)
        ])
    }

    // MARK: - Configuration
    func configureTitleButton(title: String, category: TrackerCategoryModel?) {
        titleLabel.text = title
        subtitleLabel.text = category?.categoryName
        subtitleLabel.isHidden = category == nil
    }

    func configureScheduleButton(title: String, schedule: Set<Schedule>?) {
        titleLabel.text = title
        subtitleLabel.text = schedule?.isEmpty == false ? Schedule.formattedString(from: schedule!) : nil
        subtitleLabel.isHidden = schedule?.isEmpty ?? true
    }
}
