import UIKit

class TrackerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private var headerLabel = UILabel()
    private var searchBar = UISearchBar()
    private var placeholderImage = UIImageView()
    private var placeholderText = UILabel()
    private var addTrackerButton = UIButton(type: .system)
    private var datePicker = UIDatePicker()
    
    var categories: [TrackerCategoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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

        addTrackerButton.setImage(UIImage(named: "PlusIcon"), for: .normal)
        addTrackerButton.addTarget(self, action: #selector(addTrackerButtonPressed), for: .touchUpInside)
        addTrackerButton.tintColor = UIColor.projectColor(.BackgroundBlack)
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addTrackerButton)
        
        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42)
        ])

    }
    
    func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor(hex: "#F0F0F0")
        
        datePicker.layer.cornerRadius = 8
        datePicker.locale = Locale(identifier: "ru_RU")
        
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
    
    
    @objc
    func addTrackerButtonPressed() {
        let createTrackerVC = CreateTrackerViewController()
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(createTrackerVC, animated: true)
    }
    
    @objc
    func dateTrackerButtonPressed() {
        print("date pressed")
    }
}

