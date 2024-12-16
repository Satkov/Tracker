import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    private let colorSquare = UIView()
    var cellColor: UIColor? {
        didSet {
            colorSquare.backgroundColor = cellColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorSquare)
        colorSquare.translatesAutoresizingMaskIntoConstraints = false
        colorSquare.layer.cornerRadius = 8
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
