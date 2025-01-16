import UIKit

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
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
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.projectColor(.backgroundLightGray)
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initializers
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
        contentView.insertSubview(customBackgroundView, at: 0)
        contentView.addSubview(customAccessoryView)
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
    
    private func setupCornerRadius(isFirst: Bool, isLast: Bool) {
        customBackgroundView.layer.cornerRadius = 16
        customBackgroundView.layer.masksToBounds = true
        
        if isFirst && isLast {
            customBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else if isFirst {
            customBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLast {
            customBackgroundView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            customBackgroundView.layer.cornerRadius = 0
        }
    }
    
    /// Установка кастомного аксессуара вместо стандартного accessoryType
    func setAccessoryType(_ type: UITableViewCell.AccessoryType) {
        customAccessoryView.isHidden = (type != .checkmark)
    }
}
