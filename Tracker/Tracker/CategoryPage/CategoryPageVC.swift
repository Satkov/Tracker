import UIKit

class CategoryPageViewController: UIViewController {
    private var placeholderImage = UIImageView()
    private var placeholderText = UILabel()
    private var titleLabel = UILabel()
    private var addCategoryButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupTitleLabel()
        setupPlaceholderImage()
        setupPlaceholderText()
        setupAddCategoryButton()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Категория"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupPlaceholderImage() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.image = UIImage(named: "StarPlaceholder")
        view.addSubview(placeholderImage)
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupPlaceholderText() {
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.text = "Привычки и события можно\nобъединить по смыслу"
        placeholderText.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderText.numberOfLines = 0
        placeholderText.textAlignment = .center
        view.addSubview(placeholderText)
        
        NSLayoutConstraint.activate([
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
        ])
    }
    
    private func setupAddCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        addCategoryButton.backgroundColor = UIColor.projectColor(.backgroundBlack)
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.addTarget(self, action: #selector(addSelectedDaysButtonPressed), for: .touchUpInside)
        
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func addSelectedDaysButtonPressed() {
        let createVC = CreateCategoryViewController()
        createVC.modalPresentationStyle = .pageSheet
        present(createVC, animated: true)
    }
}
