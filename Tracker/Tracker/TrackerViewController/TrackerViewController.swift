import UIKit

class TrackerViewController: UIViewController {
    var headerLabel = UILabel()
    var searchBar = UISearchBar()
    var addTrackerButton = UIButton()
    var datePicker = UIButton()
    var placeholderImage = UIImageView()
    var placeholderText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        showTrackerPlaceholder()
    }

    func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundColor")
        setupAddPickerButton()
        setupHeaderLabel()
        setupSearchBar()
    }
    
    func setupAddPickerButton() {
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackerButton.setupButton(imageName: "PlusIcon", parent: view, action: #selector (addTrackerButtonPressed), constraints: [
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45)
        ])
    }
    
    func setupHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Трекеры"
        headerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1)
        ])
    }
    
    func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 7),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            let leftView = UIImageView(image: UIImage(named: "SearchBarIcon"))
            textField.leftView = leftView
            textField.leftViewMode = .always
        }
        searchBar.placeholder = "Поиск"
    }
    
    func showTrackerPlaceholder() {
        setupPlaceholderImage()
        setupPlaceholderText()
    }
    
    func setupPlaceholderImage() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.image = UIImage(named: "StarPlaceholder")
        view.addSubview(placeholderImage)
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220)
        ])
    }
    
    func setupPlaceholderText() {
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.text = "Что будем отслеживать?"
        placeholderText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.addSubview(placeholderText)
        
        NSLayoutConstraint.activate([
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }

    
    @objc
    func addTrackerButtonPressed() {
        
    }
    

}

