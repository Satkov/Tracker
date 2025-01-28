import UIKit

final class StatisticTableViewCell: UITableViewCell {
    // MARK: - UI Elements
    private let counter: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let statisticNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let gradientLayer = CAGradientLayer()
    private let borderLayer = CAShapeLayer()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGradientBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientBorder()
    }
    
    // MARK: - Configuration
    func configurate(type: StatisticType, value: String) {
        statisticNameLabel.text = type.localized
        counter.text = value
    }

    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(counter)
        contentView.addSubview(statisticNameLabel)

        counter.translatesAutoresizingMaskIntoConstraints = false
        statisticNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            counter.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            counter.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counter.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -37),
            
            statisticNameLabel.topAnchor.constraint(equalTo: counter.bottomAnchor, constant: 7),
            statisticNameLabel.leadingAnchor.constraint(equalTo: counter.leadingAnchor),
            statisticNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Gradient Border
    private func setupGradientBorder() {
        let cornerRadius: CGFloat = 12

        gradientLayer.colors = [
            UIColor(hex: "#007BFA").cgColor,
            UIColor(hex: "#46E69D").cgColor,
            UIColor(hex: "#FD4C49").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = contentView.bounds
        gradientLayer.cornerRadius = cornerRadius

        borderLayer.lineWidth = 1
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.frame = contentView.bounds
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateGradientBorder() {
        let cornerRadius: CGFloat = 16
        let borderPath = UIBezierPath(roundedRect: contentView.bounds.insetBy(dx: 1, dy: 1), cornerRadius: cornerRadius)
        
        gradientLayer.frame = contentView.bounds
        borderLayer.path = borderPath.cgPath
        borderLayer.frame = contentView.bounds

        gradientLayer.mask = borderLayer
    }
}
