import UIKit

class EditNewTracker: UIViewController {
    var isRegular: Bool
    var scrollView = UIScrollView()
    var contentView = UIView()
    var titleLabel = UILabel()
    var trackerNameField = UITextField()
    var buttonTable = UITableView()
    var buttonsIdentifiers = ["Категория", "Расписание"]
    var emojiCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    //    var colorCollection = UICollectionView()
    
    
    
    init(type: Bool) {
        isRegular = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupScrollView()
        setupContentView()
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
    
    private func setupContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        
        addContent()
    }
    
    private func addContent() {
        setupTitleLabel()
        setupTrackerNameField()
        setupButtonsTableView()
        setupEmojiCollection()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = isRegular ? "Новая привычка" : "Новое нерегулярное событие"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
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
        
        contentView.addSubview(trackerNameField)
        
        NSLayoutConstraint.activate([
            trackerNameField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            trackerNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            trackerNameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            trackerNameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
        
        contentView.addSubview(buttonTable)
        
        let visibleRows = isRegular ? buttonsIdentifiers.count : buttonsIdentifiers.count - 1
        NSLayoutConstraint.activate([
            buttonTable.topAnchor.constraint(equalTo: trackerNameField.bottomAnchor, constant: 24),
            buttonTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonTable.heightAnchor.constraint(equalToConstant: CGFloat(visibleRows) * 75)
        ])
    }
    
    private func setupEmojiCollection() {
        emojiCollection.translatesAutoresizingMaskIntoConstraints = false
        emojiCollection.delegate = self
        emojiCollection.dataSource = self
        
        contentView.addSubview(emojiCollection)
        
        NSLayoutConstraint.activate([
            emojiCollection.topAnchor.constraint(equalTo: buttonTable.bottomAnchor, constant: 50),
            emojiCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojiCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            emojiCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        emojiCollection.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        emojiCollection.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
    }
}

extension EditNewTracker: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Emojis.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EmojiCollectionViewCell
        
        cell?.emojiLabel.text = Emojis.allCases[indexPath.item].rawValue
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String                                      // 1
        switch kind {                                       // 2
        case UICollectionView.elementKindSectionHeader:     // 3
            id = "header"
        case UICollectionView.elementKindSectionFooter:     // 4
            id = "footer"
        default:
            id = ""                                         // 5
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SupplementaryView // 6
        view.titleLabel.text = "Emoji"
        return view
    }
}

extension EditNewTracker: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

extension EditNewTracker: UICollectionViewDelegate {
    
}

extension EditNewTracker: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Убираем выделение
        let selectedOption = buttonsIdentifiers[indexPath.row]
        
        if selectedOption == "Категория" {
            print("Выбрана Категория")
        } else if selectedOption == "Расписание" {
            print("Выбрано Расписание")
        }
    }
}

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
