import UIKit

final class EditNewTrackerViewController: UIViewController {
    // MARK: - Properties
    private(set) var isRegular: Bool
    private var scrollView = UIScrollView()
    private var titleLabel = UILabel()
    private var trackerNameField = UITextField()
    private var buttonTable = UITableView()
    private var buttonsIdentifiers = ["Категория", "Расписание"]
    private var emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    private let trackerNameFieldContainer = UIView()
    private var warningLabel = UILabel()
    private var textFieldContainerHightConstraint: NSLayoutConstraint!
    private(set) var isWarningHidden = true
    
    private var presenter: EditNewTrackerPresenterProtocol?
    private var emojiCollectionManager: EmojiCollectionViewManager?
    private var colorCollectionManager: ColorCollectionManager?
    private var trackerNameFieldManager: NameTextFieldManager?
    private let params: GeometricParamsModel
    
    // MARK: - Initializer
    init(type: Bool) {
        isRegular = type
        params = GeometricParamsModel(cellCount: 6,
                                 leftInset: 18,
                                 rightInset: 19,
                                 cellSpacing: 5,
                                 cellWidth: 52,
                                 cellHeight: 52)
        super.init(nibName: nil, bundle: nil)
        presenter = EditNewTrackerPresenter(view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Setup UI
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
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = isRegular ? "Новая привычка" : "Новое нерегулярное событие"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        scrollView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16)
        ])
    }
    
    private func setupTrackerNameField() {
        trackerNameFieldManager = NameTextFieldManager(
            trackerNameField: trackerNameField,
            delegate: self,
            placeholderText: "Введите название трекера",
            presenter: presenter
        )
        trackerNameFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        
        trackerNameFieldContainer.addSubview(trackerNameField)
        scrollView.addSubview(trackerNameFieldContainer)
        
        textFieldContainerHightConstraint = trackerNameFieldContainer.heightAnchor.constraint(equalToConstant: 75)
        textFieldContainerHightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            trackerNameFieldContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            trackerNameFieldContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            trackerNameFieldContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackerNameFieldContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75),
            trackerNameField.centerXAnchor.constraint(equalTo: trackerNameFieldContainer.centerXAnchor),
            trackerNameField.leadingAnchor.constraint(equalTo: trackerNameFieldContainer.leadingAnchor),
            trackerNameField.trailingAnchor.constraint(equalTo: trackerNameFieldContainer.trailingAnchor),
        ])
    }
    
    private func setupButtonsTableView() {
        buttonTable.translatesAutoresizingMaskIntoConstraints = false
        buttonTable.delegate = self
        buttonTable.dataSource = self
        buttonTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        buttonTable.register(ButtonsTableViewCells.self, forCellReuseIdentifier: "ButtonsTableViewCells")
        buttonTable.layer.cornerRadius = 16
        
        scrollView.addSubview(buttonTable)
        
        let visibleRows = isRegular ? buttonsIdentifiers.count : buttonsIdentifiers.count - 1
        NSLayoutConstraint.activate([
            buttonTable.topAnchor.constraint(equalTo: trackerNameFieldContainer.bottomAnchor, constant: 24),
            buttonTable.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            buttonTable.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            buttonTable.heightAnchor.constraint(equalToConstant: CGFloat(visibleRows) * 75)
        ])
    }
    
    func reloadButtonTable() {
        buttonTable.reloadData()
    }
    
    private func setupEmojiCollection() {
        emojiCollectionManager = EmojiCollectionViewManager(
            collectionView: emojiCollection,
            params: params,
            presenter: presenter
        )
        
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(emojiCollection)
        
        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: buttonTable.bottomAnchor, constant: 50),
            emojiCollection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            emojiCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
    
    private func setupColorCollection() {
        colorCollectionManager = ColorCollectionManager(
            collectionView: colorCollection,
            params: params,
            presenter: presenter
        )
        
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(colorCollection)
        
        NSLayoutConstraint.activate([
            colorCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 34),
            colorCollection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            colorCollection.heightAnchor.constraint(equalToConstant: 204)
        ])
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(UIColor.projectColor(.borderRed), for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.projectColor(.borderRed).cgColor
        cancelButton.layer.cornerRadius = 16
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
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.backgroundColor = UIColor.projectColor(.textColorForLightgray)
        createButton.layer.cornerRadius = 16
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
    
    func setCreateButtonEnable() {
        createButton.backgroundColor = UIColor.projectColor(.backgroundBlack)
        createButton.isEnabled = true
    }
    
    func setCreateButtonDissable() {
        createButton.backgroundColor = UIColor.projectColor(.textColorForLightgray)
        createButton.isEnabled = false
    }
    
    @objc
    private func cancelButtonPressed() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func createButtonPressed() {
        let tracker = presenter?.createTracker()
        presenter?.saveTrackerInUserDefaults(tracker: tracker)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension EditNewTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = buttonsIdentifiers[indexPath.row]
        
        if selectedOption == "Категория" {
            let createVC = CategoryPageViewController()
            createVC.modalPresentationStyle = .pageSheet
            createVC.presenter = presenter
            createVC.lastSelectedCategory = presenter?.dataModel.category
            present(createVC, animated: true)

        } else if selectedOption == "Расписание" {
            let createVC = SchedulePageViewController()
            createVC.presenter = presenter
            if let schudule = presenter?.dataModel.schudule {
                createVC.selectedDays = schudule
            }
            createVC.modalPresentationStyle = .pageSheet
            present(createVC, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension EditNewTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isRegular ? buttonsIdentifiers.count : buttonsIdentifiers.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonsTableViewCells", for: indexPath) as? ButtonsTableViewCells else { return UITableViewCell() }
        if buttonsIdentifiers[indexPath.row] == "Категория" {
            let selectedCategory = presenter?.dataModel.category
            cell.configurateTitleButton(title: buttonsIdentifiers[indexPath.row], category: selectedCategory)
        } else {
            let schedule = presenter?.dataModel.schudule
            cell.configureSheduleButton(title: buttonsIdentifiers[indexPath.row], schedule: schedule)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension EditNewTrackerViewController: TrackerNameTextFieldManagerDelegateProtocol {
    func showWarningLabel() {
        textFieldContainerHightConstraint.constant = 113
        setupWarningLabel()
        UIView.animate(withDuration: 0) {
            self.scrollView.layoutIfNeeded()
        }
        isWarningHidden = false
    }
    
    func hideWarningLabel() {
        textFieldContainerHightConstraint.constant = 75
        warningLabel.removeFromSuperview()
        isWarningHidden = true
    }
    
    private func setupWarningLabel() {
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.text = "Ограничение 38 символов"
        warningLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        warningLabel.textColor = UIColor.projectColor(.borderRed)
        
        trackerNameFieldContainer.addSubview(warningLabel)
        
        NSLayoutConstraint.activate([
            warningLabel.centerXAnchor.constraint(equalTo: trackerNameField.centerXAnchor),
            warningLabel.heightAnchor.constraint(equalToConstant: 22),
            warningLabel.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 8)
        ])
    }
}

extension EditNewTrackerViewController: EditNewTrackerViewControllerProtocol { }
