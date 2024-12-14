import UIKit


class CreateCategoryViewController: UIViewController {
    private var titleLabel = UILabel()
    private var addCategoryButton = UIButton()
    private var trackerNameField = UITextField()
    
    private var trackerNameFieldManager: TrackerNameTextFieldManager?
    private var categoryManager: TrackerCategoryManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupTitleLabel()
        setupTrackerNameField()
        setupReadyButton()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Новая категория"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTrackerNameField() {
        trackerNameFieldManager = TrackerNameTextFieldManager(
            trackerNameField: trackerNameField,
            delegate: nil,
            placeholderText: "Введите название категории"
        )
        trackerNameField.delegate = self
        view.addSubview(trackerNameField)
        
        NSLayoutConstraint.activate([
            trackerNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            trackerNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupReadyButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setTitle("Готово", for: .normal)
        addCategoryButton.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.addTarget(self, action: #selector(readyButtonPressed), for: .touchUpInside)
        disableReadyButton()
        view.addSubview(addCategoryButton)
        
        NSLayoutConstraint.activate([
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func enableReadyButton() {
        addCategoryButton.backgroundColor = UIColor.projectColor(.backgroundBlack)
        addCategoryButton.isEnabled = true
    }
    
    private func disableReadyButton() {
        addCategoryButton.backgroundColor = UIColor.projectColor(.textColorForLightgray)
        addCategoryButton.isEnabled = false
    }
    
    @objc
    private func readyButtonPressed() {
        if let newCategoryName = trackerNameField.text {
            let newTracker = TrackerCategoryModel(categoryName: newCategoryName)
            categoryManager = TrackerCategoryManager()
            categoryManager?.addCategory(newTracker)
            dismiss(animated: true)
        }
    }
}

extension CreateCategoryViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, !text.isEmpty {
            enableReadyButton()
        } else {
            disableReadyButton()
        }
        return true
    }
}
