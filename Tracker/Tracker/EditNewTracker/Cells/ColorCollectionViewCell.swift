import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    var cellColor: UIColor? {
        didSet {
            contentView.backgroundColor = cellColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = cellColor
        contentView.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
