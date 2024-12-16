import UIKit

final class ButtonsTableViewCells: UITableViewCell {
    var labelsContainer = UIView()
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var arrowImageView = UIImageView()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Add labels container to cell
        contentView.addSubview(labelsContainer)
        contentView.backgroundColor = UIColor.projectColor(.backgroundLightGray)
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure title label
        labelsContainer.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor.projectColor(.backgroundBlack)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure subtitle label
        labelsContainer.addSubview(subtitleLabel)
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        subtitleLabel.textColor = UIColor.projectColor(.textColorForLightgray)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure arrow image
        contentView.addSubview(arrowImageView)
        arrowImageView.tintColor = .gray
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
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
    func configurateTitleButton(title: String, category: TrackerCategoryModel?) {
        titleLabel.text = title
        if let subtitle = category {
            subtitleLabel.text = subtitle.categoryName
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
    }
    
    func configureSheduleButton(title: String, schedule: Set<Schedule>?) {
        titleLabel.text = title
        if let subtitle = schedule, !subtitle.isEmpty {
            subtitleLabel.text = Schedule.formattedString(from: subtitle)
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
    }
}
