import UIKit

final class EditNewTrackerViewController: UIViewController {
    // MARK: - Constants
    private let params = GeometricParamsModel(
        cellCount: 6,
        leftInset: 18,
        rightInset: 19,
        cellSpacing: 5,
        cellWidth: 52,
        cellHeight: 52
    )

    // MARK: - State Properties
    private(set) var isRegular: Bool
    private(set) var isWarningHidden = true
    var onTrackerCreation: (() -> Void)?

    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let trackerNameFieldContainer = UIView()
    private let emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let trackerNameField = UITextField()

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = UIColor.projectColor(.borderRed)
        return label
    }()

    private let buttonTable: UITableView = {
        let table = UITableView()
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.layer.cornerRadius = 16
        return table
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor.projectColor(.borderRed), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.projectColor(.borderRed).cgColor
        button.layer.cornerRadius = 16
        return button
    }()

    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.projectColor(.textColorForLightgray)
        button.layer.cornerRadius = 16
        return button
    }()
    
    // MARK: - Constraints
    private var textFieldContainerHeightConstraint: NSLayoutConstraint!

    // MARK: - Data and Managers
    private let buttonsIdentifiers = ["Категория", "Расписание"]
    private var presenter: EditNewTrackerPresenterProtocol
    private var emojiCollectionManager: EmojiCollectionViewManager
    private var colorCollectionManager: ColorCollectionManager
    private var trackerNameFieldManager: NameTextFieldManager


    // MARK: - Initializer

    init(
        type: Bool,
        presenter: EditNewTrackerPresenterProtocol
    ) {
        self.isRegular = type
        self.presenter = presenter
        self.emojiCollectionManager = EmojiCollectionViewManager(
            collectionView: emojiCollection,
            params: params,
            presenter: presenter
        )
        
        self.trackerNameFieldManager = NameTextFieldManager(
            trackerNameField: trackerNameField,
            placeholderText: "Введите название трекера",
            presenter: presenter
        )
        
        self.colorCollectionManager = ColorCollectionManager(
            collectionView: colorCollection,
            params: params,
            presenter: presenter
        )
        super.init(nibName: nil, bundle: nil)
        
        presenter.configure(view: self)
        trackerNameFieldManager.addDelegate(delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.onTrackerCreation = onTrackerCreation
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupScrollView()
        addContent()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func addContent() {
        setupTitleLabel()
        setupTrackerNameField()
        setupButtonsTableView()
        setupEmojiCollection()
        setupColorCollection()
        setupCancelButton()
        setupCreateButton()
    }

    // MARK: - Subview Setup

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = isRegular ? "Новая привычка" : "Новое нерегулярное событие"
        scrollView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16)
        ])
    }

    private func setupWarningLabel() {
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerNameFieldContainer.addSubview(warningLabel)

        NSLayoutConstraint.activate([
            warningLabel.centerXAnchor.constraint(equalTo: trackerNameField.centerXAnchor),
            warningLabel.heightAnchor.constraint(equalToConstant: 22),
            warningLabel.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 8)
        ])
    }

    private func setupTrackerNameField() {
        trackerNameFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        trackerNameFieldContainer.addSubview(trackerNameField)
        
        scrollView.addSubview(trackerNameFieldContainer)

        textFieldContainerHeightConstraint = trackerNameFieldContainer.heightAnchor.constraint(equalToConstant: 75)
        textFieldContainerHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            trackerNameFieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            trackerNameFieldContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            trackerNameFieldContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackerNameFieldContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameField.centerXAnchor.constraint(equalTo: trackerNameFieldContainer.centerXAnchor),
            trackerNameField.leadingAnchor.constraint(equalTo: trackerNameFieldContainer.leadingAnchor),
            trackerNameField.trailingAnchor.constraint(equalTo: trackerNameFieldContainer.trailingAnchor)
        ])
    }

    private func setupButtonsTableView() {
        buttonTable.translatesAutoresizingMaskIntoConstraints = false
        buttonTable.delegate = self
        buttonTable.dataSource = self
        buttonTable.register(ButtonsTableViewCells.self, forCellReuseIdentifier: "ButtonsTableViewCells")
        scrollView.addSubview(buttonTable)

        let visibleRows = isRegular ? buttonsIdentifiers.count : buttonsIdentifiers.count - 1
        NSLayoutConstraint.activate([
            buttonTable.topAnchor.constraint(equalTo: trackerNameFieldContainer.bottomAnchor, constant: 24),
            buttonTable.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            buttonTable.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            buttonTable.heightAnchor.constraint(equalToConstant: CGFloat(visibleRows) * 75)
        ])
    }

    private func setupEmojiCollection() {

        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(emojiCollection)

        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: buttonTable.bottomAnchor, constant: 34),
            emojiCollection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            emojiCollection.heightAnchor.constraint(equalToConstant: 228)
        ])
    }

    private func setupColorCollection() {
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(colorCollection)

        NSLayoutConstraint.activate([
            colorCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 34),
            colorCollection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            colorCollection.heightAnchor.constraint(equalToConstant: 228)
        ])
    }

    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        scrollView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func setupCreateButton() {
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)

        scrollView.addSubview(createButton)

        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: colorCollection.bottomAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 4),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc
    private func cancelButtonPressed() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @objc
    private func createButtonPressed() {
        let tracker = presenter.createTracker()
        presenter.saveTracker(tracker: tracker)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension EditNewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        }
    }
    
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 75
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = buttonsIdentifiers[indexPath.row]

        switch selectedOption {
        case "Категория":
            let createVC = CategoryPageViewController(
                presenter: presenter,
                lastSelectedCategory: presenter.dataModel.category
            )
            createVC.modalPresentationStyle = .pageSheet
            present(createVC, animated: true)

        case "Расписание":
            let createVC = SchedulePageViewController(
                presenter: presenter,
                selectedDays: presenter.dataModel.schudule)
            createVC.modalPresentationStyle = .pageSheet
            present(createVC, animated: true)

        default:
            // TODO: обработка ошибки
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension EditNewTrackerViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return isRegular ? buttonsIdentifiers.count : buttonsIdentifiers.count - 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "ButtonsTableViewCells",
            for: indexPath
        ) as? ButtonsTableViewCells else { return UITableViewCell() }

        let identifier = buttonsIdentifiers[indexPath.row]

        switch identifier {
        case "Категория":
            let selectedCategory = presenter.dataModel.category
            cell.configureTitleButton(title: identifier, category: selectedCategory)

        case "Расписание":
            let schedule = presenter.dataModel.schudule
            cell.configureScheduleButton(title: identifier, schedule: schedule)

        default:
            break
        }

        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - TrackerNameTextFieldManagerDelegateProtocol
extension EditNewTrackerViewController: TrackerNameTextFieldManagerDelegateProtocol {
    func showWarningLabel() {
        textFieldContainerHeightConstraint.constant = 113
        setupWarningLabel()
        UIView.animate(withDuration: 0) {
            self.scrollView.layoutIfNeeded()
        }
        isWarningHidden = false
    }

    func hideWarningLabel() {
        textFieldContainerHeightConstraint.constant = 75
        warningLabel.removeFromSuperview()
        isWarningHidden = true
    }
}

extension EditNewTrackerViewController: EditNewTrackerViewControllerProtocol {
    func setCreateButtonEnable() {
        createButton.backgroundColor = UIColor.projectColor(.backgroundBlack)
        createButton.isEnabled = true
    }

    func setCreateButtonDissable() {
        createButton.backgroundColor = UIColor.projectColor(.textColorForLightgray)
        createButton.isEnabled = false
    }

    func reloadButtonTable() {
        buttonTable.reloadData()
    }
}
