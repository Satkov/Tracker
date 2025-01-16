import UIKit

final class CategoryPageViewController: UIViewController {
    // MARK: - UI Elements
    private let placeholderImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "StarPlaceholder")
        return view
    }()
    private let placeholderText: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private let categoriesTable = UITableView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    private let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        button.backgroundColor = UIColor.projectColor(.backgroundBlack)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    private let contentViewForTable: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        return view
    }()

    // MARK: - Properties
    private var trackerCategoryList: [TrackerCategoryModel] = []
    private var trackerCategoryManager = TrackerCategoryManager.shared
    private var presenter: EditNewTrackerPresenterProtocol
    private var lastSelectedCategory: TrackerCategoryModel?

    
    init(
        presenter: EditNewTrackerPresenterProtocol,
        lastSelectedCategory: TrackerCategoryModel?
    ) {
        self.presenter = presenter
        self.lastSelectedCategory = lastSelectedCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        trackerCategoryList = trackerCategoryManager.loadCategories()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupTitleLabel()
        setupAddCategoryButton()
        trackerCategoryList.isEmpty ? setupPlaceholder() : setupCategoriesTable()
    }

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupAddCategoryButton() {
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonPressed), for: .touchUpInside)
        view.addSubview(addCategoryButton)

        NSLayoutConstraint.activate([
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func setupCategoriesTable() {
        contentViewForTable.translatesAutoresizingMaskIntoConstraints = false
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        categoriesTable.delegate = self
        categoriesTable.dataSource = self
        categoriesTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        categoriesTable.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        contentViewForTable.addSubview(categoriesTable)
        view.addSubview(contentViewForTable)

        NSLayoutConstraint.activate([
            contentViewForTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            contentViewForTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentViewForTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentViewForTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20),

            categoriesTable.topAnchor.constraint(equalTo: contentViewForTable.topAnchor),
            categoriesTable.leadingAnchor.constraint(equalTo: contentViewForTable.leadingAnchor),
            categoriesTable.trailingAnchor.constraint(equalTo: contentViewForTable.trailingAnchor),
            categoriesTable.bottomAnchor.constraint(equalTo: contentViewForTable.bottomAnchor)
        ])
    }

    private func setupPlaceholder() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderImage)

        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderText)

        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),

            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }

    // MARK: - Actions
    @objc
    private func addCategoryButtonPressed() {
        let createVC = CreateCategoryViewController(delegate: self)
        createVC.modalPresentationStyle = .pageSheet
        present(createVC, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension CategoryPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = trackerCategoryList[indexPath.row]
        presenter.updateCategory(new: selectedCategory)
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CategoryPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerCategoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CategoryTableViewCell",
            for: indexPath
        ) as? CategoryTableViewCell else {
            return UITableViewCell()
        }

        let category = trackerCategoryList[indexPath.row]
        let isSelected = lastSelectedCategory?.categoryName == category.categoryName
        let isLast = indexPath.row == trackerCategoryList.count - 1
        let isFirst = indexPath.row == 0

        cell.configureCell(with: category.categoryName, isSelected: isSelected, isLast: isLast, isFirst: isFirst)

        return cell
    }
}

extension CategoryPageViewController: CategoryPageViewControllerProtocol {
    func newCategoryWereAdded() {
        trackerCategoryList = trackerCategoryManager.loadCategories()

        DispatchQueue.main.async {
            if self.trackerCategoryList.isEmpty {
                self.contentViewForTable.removeFromSuperview()
                self.setupPlaceholder()
            } else {
                self.placeholderImage.removeFromSuperview()
                self.placeholderText.removeFromSuperview()

                if self.contentViewForTable.superview == nil {
                    self.setupCategoriesTable()
                }
                self.categoriesTable.reloadData()
            }
        }
    }
}
