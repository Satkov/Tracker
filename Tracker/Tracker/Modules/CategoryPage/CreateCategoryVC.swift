import UIKit

final class CreateCategoryViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.newCategoryTitle
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    private let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.readyButton, for: .normal)
        button.setTitleColor(UIColor.projectColor(.white), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    private let trackerNameField = UITextField()

    // MARK: - Managers
    private let trackerNameFieldManager: NameTextFieldManager?
    private var categoryDataProvider: CategoryDataProvider!

    init() {
        categoryDataProvider = CategoryDataProvider(delegate: nil)
        trackerNameFieldManager = NameTextFieldManager(
            trackerNameField: trackerNameField,
            placeholderText: Localization.createTrackerNamePlaceholder,
            presenter: nil
        )
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
        setupGestureRecognizer()
        trackerNameField.delegate = self
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
        setAddCategoryButtonState(isTextFieldEmpty: true)
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

    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Button State Management
    private func setAddCategoryButtonState(isTextFieldEmpty: Bool) {
        let backgroundcolor: ProjectColors = isTextFieldEmpty ? .gray : .black
        let textColor: ProjectColors = isTextFieldEmpty ? .alwaysWhite : .white
        addCategoryButton.setTitleColor(UIColor.projectColor(textColor), for: .normal)
        addCategoryButton.backgroundColor = UIColor.projectColor(backgroundcolor)
        addCategoryButton.isEnabled = !isTextFieldEmpty
    }

    // MARK: - Actions
    @objc
    private func addCategoryButtonPressed() {
        guard let newCategoryName = trackerNameField.text, !newCategoryName.isEmpty else { return }
        try? categoryDataProvider.addCategory(name: newCategoryName)
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension CreateCategoryViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let currentText = textField.text as NSString? else {
            setAddCategoryButtonState(isTextFieldEmpty: true)
            return true
        }

        let updatedText = currentText.replacingCharacters(in: range, with: string)
        setAddCategoryButtonState(isTextFieldEmpty: updatedText.isEmpty)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateCategoryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
