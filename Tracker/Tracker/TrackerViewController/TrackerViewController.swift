import UIKit

class TrackerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private var headerLabel = UILabel()
    private var searchBar = UISearchBar()
    private var addTrackerButton = UIButton()
    private var datePicker = UIButton()
    private var placeholderImage = UIImageView()
    private var placeholderText = UILabel()
    
    var categories: [TrackerCategoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        showTrackerPlaceholder()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupAddTrackerButton()
        setupHeaderLabel()
        setupSearchBar()
        setupDatePicker()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupAddTrackerButton() {
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        addTrackerButton.setupButton(imageName: "PlusIcon", parent: view, action: #selector (addTrackerButtonPressed), constraints: [
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45)
        ])
    }
    
    private func setupHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Трекеры"
        headerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1)
        ])
    }
    
    private func setupSearchBar() {
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
    
    private func showTrackerPlaceholder() {
        setupPlaceholderImage()
        setupPlaceholderText()
    }
    
    private func setupPlaceholderImage() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.image = UIImage(named: "StarPlaceholder")
        view.addSubview(placeholderImage)
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220)
        ])
    }
    
    private func setupPlaceholderText() {
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.text = "Что будем отслеживать?"
        placeholderText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.addSubview(placeholderText)
        
        NSLayoutConstraint.activate([
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }
    
    func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.backgroundColor = UIColor(hex: "#F0F0F0")
        datePicker.setTitle(Date().toShortDateString(), for: .normal)
        datePicker.layer.cornerRadius = 8
        datePicker.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        datePicker.setTitleColor(UIColor(named: "TrackerBackgroundBlack"), for: .normal)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 77),
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
    }
    
    
    @objc
    func addTrackerButtonPressed() {
        print("ASd")
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(createTrackerVC, animated: true)
    }
    
    
}

