import UIKit

final class CreateCategoryViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    private let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    private let trackerNameField = UITextField()

    // MARK: - Managers
    private let trackerNameFieldManager: NameTextFieldManager?
    private let categoryManager = TrackerCategoryManager.shared

    private let delegate: CategoryPageViewControllerProtocol

    init(delegate: CategoryPageViewControllerProtocol) {
        trackerNameFieldManager = NameTextFieldManager(
            trackerNameField: trackerNameField,
            placeholderText: "Введите название категории",
            presenter: nil
        )
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        prepareViews()
        setupTrackerNameField()
        setupAddCategoryButton()
        setupConstraints()
    }
    
    private func prepareViews() {
        [titleLabel,
         trackerNameField,
         addCategoryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupTrackerNameField() {
        trackerNameField.delegate = self
    }

    private func setupAddCategoryButton() {
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        disableAddCategoryButton()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackerNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackerNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            trackerNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Button State Management
    private func enableAddCategoryButton() {
        addCategoryButton.backgroundColor = UIColor.projectColor(.backgroundBlack)
        addCategoryButton.isEnabled = true
    }

    private func disableAddCategoryButton() {
        addCategoryButton.backgroundColor = UIColor.projectColor(.textColorForLightgray)
        addCategoryButton.isEnabled = false
    }

    // MARK: - Actions
    @objc
    private func addCategoryButtonPressed() {
        guard let newCategoryName = trackerNameField.text, !newCategoryName.isEmpty else { return }
        let newTracker = TrackerCategoryModel(categoryName: newCategoryName)
        categoryManager.addCategory(newTracker)
        delegate.newCategoryWereAdded()
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension CreateCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else {
            disableAddCategoryButton()
            return true
        }

        let updatedText = currentText.replacingCharacters(in: range, with: string)
        updatedText.isEmpty ? disableAddCategoryButton() : enableAddCategoryButton()
        return true
    }
}
