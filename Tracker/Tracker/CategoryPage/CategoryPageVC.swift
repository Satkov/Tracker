import UIKit

final class CategoryPageViewController: UIViewController {
    private var placeholderImage = UIImageView()
    private var placeholderText = UILabel()
    private var catregoriesTable = UITableView()
    private var titleLabel = UILabel()
    private var addCategoryButton = UIButton()
    private var observer: NSObjectProtocol?
    private var selectedIndexPath: IndexPath?
    private let contentViewForTable = UIView()
    private var tableHeightConstraint: NSLayoutConstraint!
    
    private var trackerCategoryList: [TrackerCategoryModel]!
    private var trackerCategoryManager: TrackerCategoryManager!
    var presenter: EditNewTrackerPresenterProtocol?
    var lastSelectedCategory: TrackerCategoryModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerCategoryManager = TrackerCategoryManager()
        trackerCategoryList = trackerCategoryManager.loadCategories()
        setupUI()
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupTitleLabel()
        setupAddCategoryButton()
        if trackerCategoryList.isEmpty {
            setupPlaceholderImage()
            setupPlaceholderText()
        } else {
            setupCatregoriesTable()
        }
    }
    
    private func addObserver() {
        observer = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.userDefaultsDidChange()
        }
    }
    
    private func removeObserver() {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func userDefaultsDidChange() {
        trackerCategoryList = trackerCategoryManager.loadCategories()
        DispatchQueue.main.async {
            self.placeholderImage.removeFromSuperview()
            self.placeholderText.removeFromSuperview()
            
            if self.catregoriesTable.superview == nil {
                self.setupCatregoriesTable()
            } else {
                self.catregoriesTable.reloadData()
            }
            
        }
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
    
    private func setupCatregoriesTable() {
        contentViewForTable.translatesAutoresizingMaskIntoConstraints = false
        contentViewForTable.layer.cornerRadius = 16
        catregoriesTable.translatesAutoresizingMaskIntoConstraints = false
        catregoriesTable.delegate = self
        catregoriesTable.dataSource = self
        catregoriesTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        catregoriesTable.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        catregoriesTable.layer.cornerRadius = 16
        catregoriesTable.tableFooterView = UIView()
        
        contentViewForTable.addSubview(catregoriesTable)
        view.addSubview(contentViewForTable)
        
        NSLayoutConstraint.activate([
            contentViewForTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            contentViewForTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentViewForTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentViewForTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20),
            
            catregoriesTable.topAnchor.constraint(equalTo: contentViewForTable.topAnchor),
            catregoriesTable.leadingAnchor.constraint(equalTo: contentViewForTable.leadingAnchor),
            catregoriesTable.trailingAnchor.constraint(equalTo: contentViewForTable.trailingAnchor),
            catregoriesTable.bottomAnchor.constraint(equalTo: contentViewForTable.bottomAnchor)
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

extension CategoryPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell
        cell?.setAccessoryType(.checkmark)
        presenter?.updateCategory(new: trackerCategoryList[indexPath.row])
        dismiss(animated: true)
    }
}

extension CategoryPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        let categoryName = trackerCategoryList[indexPath.row].categoryName
        let isSelected = lastSelectedCategory?.categoryName == categoryName
        let isLast = indexPath.row == trackerCategoryList.count - 1
        let isFirst = indexPath.row == 0

        cell.configureCell(with: categoryName, isSelected: isSelected, isLast: isLast, isFirst: isFirst)

        return cell
    }
    
    
}
