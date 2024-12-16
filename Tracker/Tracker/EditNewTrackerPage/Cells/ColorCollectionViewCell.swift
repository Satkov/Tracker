import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    private let colorSquare: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
    }()
    
    var cellColor: UIColor? {
        didSet {
            colorSquare.backgroundColor = cellColor
        }
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(colorSquare)
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        NSLayoutConstraint.activate([
            colorSquare.widthAnchor.constraint(equalToConstant: 40),
            colorSquare.heightAnchor.constraint(equalToConstant: 40),
            colorSquare.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorSquare.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
