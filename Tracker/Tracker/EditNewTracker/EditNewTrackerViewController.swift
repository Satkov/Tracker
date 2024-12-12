import UIKit

class EditNewTracker: UIViewController {
    // MARK: - Properties
    var isRegular: Bool
    var scrollView = UIScrollView()
    var titleLabel = UILabel()
    var trackerNameField = UITextField()
    var buttonTable = UITableView()
    var buttonsIdentifiers = ["Категория", "Расписание"]
    var emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var colorCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var emojiCollectionManager: EmojiCollectionViewManager?
    private var colorCollectionManager: ColorCollectionManager?
    private let params: GeometricParams
    
    // MARK: - Initializer
    init(type: Bool) {
        isRegular = type
        params = GeometricParams(cellCount: 6,
                                 leftInset: 18,
                                 rightInset: 19,
                                 cellSpacing: 5,
                                 cellWidth: 52,
                                 cellHeight: 52)
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
        trackerNameField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerNameField.layer.cornerRadius = 16
        trackerNameField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColorForLightgray") ?? .gray]
        )
        trackerNameField.textColor = UIColor(named: "TrackerBackgroundBlack")
        trackerNameField.backgroundColor = UIColor(named: "TrackerBackgroundLightGray")
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameField.frame.height))
        trackerNameField.leftView = paddingView
        trackerNameField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameField.frame.height))
        trackerNameField.rightView = rightPaddingView
        trackerNameField.rightViewMode = .always
        
        scrollView.addSubview(trackerNameField)
        
        NSLayoutConstraint.activate([
            trackerNameField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            trackerNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            trackerNameField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackerNameField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func setupButtonsTableView() {
        buttonTable.translatesAutoresizingMaskIntoConstraints = false
        buttonTable.delegate = self
        buttonTable.dataSource = self
        buttonTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        buttonTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        buttonTable.layer.cornerRadius = 16
        
        scrollView.addSubview(buttonTable)
        
        let visibleRows = isRegular ? buttonsIdentifiers.count : buttonsIdentifiers.count - 1
        NSLayoutConstraint.activate([
            buttonTable.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 24),
            buttonTable.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            buttonTable.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            buttonTable.heightAnchor.constraint(equalToConstant: CGFloat(visibleRows) * 75)
        ])
    }
    
    private func setupEmojiCollection() {
        emojiCollectionManager = EmojiCollectionViewManager(
            collectionView: emojiCollection,
            params: params
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
            params: params
        )
        
        colorCollection.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(colorCollection)
        
        NSLayoutConstraint.activate([
            colorCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor, constant: 34),
            colorCollection.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            colorCollection.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            colorCollection.heightAnchor.constraint(equalToConstant: 204),
            colorCollection.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension EditNewTracker: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOption = buttonsIdentifiers[indexPath.row]
        
        if selectedOption == "Категория" {
            print("Выбрана Категория")
        } else if selectedOption == "Расписание" {
            print("Выбрано Расписание")
        }
    }
}

// MARK: - UITableViewDataSource
extension EditNewTracker: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isRegular ? buttonsIdentifiers.count : buttonsIdentifiers.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = buttonsIdentifiers[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.systemGray6
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - GeometricParams
struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let cellWidth: CGFloat
    let cellHeight: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat, cellWidth: CGFloat, cellHeight: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.cellWidth = cellWidth
        self.cellHeight = cellHeight
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
