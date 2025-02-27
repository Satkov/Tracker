import UIKit

final class EditTrackerViewController: UIViewController {
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
    private let isNewTracker: Bool

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

    private let recordsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let trackerNameField = UITextField()

    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.nameFieldMaxLengthWarning
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
        button.setTitle(Localization.cancelButton, for: .normal)
        button.setTitleColor(UIColor.projectColor(.borderRed), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.projectColor(.borderRed).cgColor
        button.layer.cornerRadius = 16
        return button
    }()

    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.projectColor(.alwaysWhite), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.projectColor(.gray)
        button.layer.cornerRadius = 16
        return button
    }()

    // MARK: - Constraints
    private var textFieldContainerHeightConstraint: NSLayoutConstraint!

    // MARK: - Data and Managers
    private let buttonsIdentifiers = [Localization.categoryTitle, Localization.scheduleTitle]
    private var presenter: EditTrackerPresenterProtocol
    private var emojiCollectionManager: EmojiCollectionViewManager
    private var colorCollectionManager: ColorCollectionManager
    private var trackerNameFieldManager: NameTextFieldManager
    private let editedTrackerData: DataForTrackerModel?
    private let recordsCount: Int?

    // MARK: - Initializer

    init(
        type: Bool,
        presenter: EditTrackerPresenterProtocol,
        editedTrackerData: DataForTrackerModel?,
        recordsCount: Int?
    ) {
        self.isRegular = type
        self.presenter = presenter
        self.editedTrackerData = editedTrackerData
        self.emojiCollectionManager = EmojiCollectionViewManager(
            collectionView: emojiCollection,
            params: params,
            presenter: presenter
        )

        self.trackerNameFieldManager = NameTextFieldManager(
            trackerNameField: trackerNameField,
            placeholderText: Localization.typeCategoryNamePlaceholder,
            presenter: presenter
        )

        self.colorCollectionManager = ColorCollectionManager(
            collectionView: colorCollection,
            params: params,
            presenter: presenter
        )
        isNewTracker = editedTrackerData == nil
        self.recordsCount = recordsCount
        super.init(nibName: nil, bundle: nil)
        presenter.configure(view: self, editedTrackerData: editedTrackerData)
        trackerNameFieldManager.addDelegate(delegate: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestureRecognizer()
        fillFormWithData()
    }

    // MARK: - UI Setup

    private func fillFormWithData() {
        if let tracker = editedTrackerData {
            trackerNameField.text = tracker.name
            emojiCollectionManager.setSelectedEmoji(tracker.emoji)
            colorCollectionManager.setSelectedColor(tracker.color)
        }
    }
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
        setupRecordsLabel()
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
        let newTrackerTitle = isRegular ? Localization.editNewTrackerTitleHabit: Localization.editNewTrackerTitleIrregular
        let title = isNewTracker ? newTrackerTitle : "Редактирование привычки"
        titleLabel.text = title
        scrollView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16)
        ])
    }

    private func setupRecordsLabel() {
        guard !isNewTracker,
              let counter = recordsCount
        else { return }
        recordsLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(recordsLabel)
        let localizedString = String.localizedStringWithFormat(
            NSLocalizedString("daysCount", comment: ""),
            counter
        )
        recordsLabel.text = localizedString

        NSLayoutConstraint.activate([
            recordsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            recordsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            recordsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }

    private func setupTrackerNameField() {
        trackerNameFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        trackerNameFieldContainer.addSubview(trackerNameField)

        scrollView.addSubview(trackerNameFieldContainer)

        textFieldContainerHeightConstraint = trackerNameFieldContainer.heightAnchor.constraint(equalToConstant: 75)
        textFieldContainerHeightConstraint.isActive = true

        let topConstraint = isNewTracker ?
        trackerNameFieldContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38) :
        trackerNameFieldContainer.topAnchor.constraint(equalTo: recordsLabel.bottomAnchor, constant: 40)

        NSLayoutConstraint.activate([
            trackerNameFieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            topConstraint,
            trackerNameFieldContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackerNameFieldContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameField.centerXAnchor.constraint(equalTo: trackerNameFieldContainer.centerXAnchor),
            trackerNameField.leadingAnchor.constraint(equalTo: trackerNameFieldContainer.leadingAnchor),
            trackerNameField.trailingAnchor.constraint(equalTo: trackerNameFieldContainer.trailingAnchor)
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
        let title = self.isNewTracker ? Localization.createButton : "Сохранить"
        createButton.setTitle(title, for: .normal)
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

    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
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
        if isNewTracker {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate
extension EditTrackerViewController: UITableViewDelegate {
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
        case Localization.categoryTitle:
            let createVC = CategoryPageViewController(
                presenter: presenter,
                lastSelectedCategory: presenter.dataModel.category
            )
            createVC.modalPresentationStyle = .pageSheet
            present(createVC, animated: true)

        case Localization.scheduleTitle:
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
extension EditTrackerViewController: UITableViewDataSource {
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
        case Localization.categoryTitle:
            let selectedCategory = presenter.dataModel.category
            cell.configureTitleButton(title: identifier, category: selectedCategory)

        case Localization.scheduleTitle:
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
extension EditTrackerViewController: TrackerNameTextFieldManagerDelegateProtocol {
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

extension EditTrackerViewController: EditTrackerViewControllerProtocol {

    func setCreateButtonEnable() {
        createButton.backgroundColor = UIColor.projectColor(.black)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                createButton.setTitleColor(UIColor.projectColor(.alwaysblack), for: .normal)
            }
        }
        createButton.isEnabled = true
    }

    func setCreateButtonDissable() {
        createButton.backgroundColor = UIColor.projectColor(.gray)
        createButton.setTitleColor(UIColor.projectColor(.alwaysWhite), for: .normal)
        createButton.isEnabled = false
    }

    func reloadButtonTable() {
        buttonTable.reloadData()
    }
}
