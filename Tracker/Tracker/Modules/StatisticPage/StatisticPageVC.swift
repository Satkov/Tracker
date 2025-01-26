import UIKit

final class StatisticPageViewController: UIViewController {
    private let headerView = UIView()
    private let headerlabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = Localization.statisticTitle
        return label
    }()
    
    private let placeholderImage = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CryingFace") ?? UIImage()
        return imageView
    }()
    
    private let placeholderText = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = Localization.statisticPagePlaceholder
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.projectColor(.backgroundWhite)
        prepareViews()
        setupLayouts()
    }
    
    private func prepareViews() {
        [headerView,
         placeholderText,
         placeholderImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        headerlabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerlabel)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 182)
        ])
        
        NSLayoutConstraint.activate([
            headerlabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 88),
            headerlabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerlabel.widthAnchor.constraint(equalToConstant: 254)
        ])
        
        NSLayoutConstraint.activate([
            placeholderImage.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 193),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            placeholderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
