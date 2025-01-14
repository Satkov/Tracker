import UIKit

final class CreateCategoryViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let addCategoryButton = UIButton()
    private let trackerNameField = UITextField()

    // MARK: - Managers
    private var trackerNameFieldManager: NameTextFieldManager?
    private var categoryManager = TrackerCategoryManager.shared

    var delegate: CategoryPageViewControllerProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupTitleLabel()
        setupTrackerNameField()
        setupAddCategoryButton()
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
        trackerNameFieldManager = NameTextFieldManager(
            trackerNameField: trackerNameField,
            delegate: nil,
            placeholderText: "Введите название категории",
            presenter: nil
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

    private func setupAddCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.setTitle("Готово", for: .normal)
        addCategoryButton.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        disableAddCategoryButton()
        view.addSubview(addCategoryButton)

        NSLayoutConstraint.activate([
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
        delegate?.newCategoryWereAdded()
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
