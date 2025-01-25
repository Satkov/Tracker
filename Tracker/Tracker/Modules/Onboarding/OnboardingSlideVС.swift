import Foundation
import UIKit

final class OnboardingSlideViewController: UIViewController {
    private let pageNumber: PageNumber
    
    private let label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    init(pageNumber: PageNumber) {
        self.pageNumber = pageNumber
        super.init(nibName: nil, bundle: nil)
        setupBackground()
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupBackground() {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = pageNumber.backgroundImage()
        backgroundImage.contentMode = .scaleAspectFill
        
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }
    
    func setupTextField() {
        label.text = pageNumber.text()
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304)
        ])
    }
}
