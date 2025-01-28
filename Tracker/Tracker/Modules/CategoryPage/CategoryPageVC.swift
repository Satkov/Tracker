import UIKit

final class CategoryPageViewController: UIViewController {

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.categoryTitle
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.addCategoryButton, for: .normal)
        button.setTitleColor(UIColor.projectColor(.white), for: .normal)
        button.backgroundColor = UIColor.projectColor(.black)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()

    private let placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StarPlaceholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let placeholderText: UILabel = {
        let label = UILabel()
        label.text = Localization.categoryPagePlaceholder
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewModel: CategoryViewModel = {
        let viewModel = CategoryViewModel()
        return viewModel
    }()

    private let viewWithCategoryTableView: ViewWithCategoryTableView

    // MARK: - Properties
    private var presenter: EditNewTrackerPresenterProtocol
    private var lastSelectedCategory: TrackerCategoryModel?
    private var categoryDataProvider: CategoryDataProvider!

    // MARK: - Initializer
    init(
        presenter: EditNewTrackerPresenterProtocol,
        lastSelectedCategory: TrackerCategoryModel?
    ) {
        self.presenter = presenter
        self.lastSelectedCategory = lastSelectedCategory
        self.viewWithCategoryTableView = ViewWithCategoryTableView(
            frame: .zero,
            presenter: presenter
        )
        
        super.init(nibName: nil, bundle: nil)

        viewWithCategoryTableView.configurate(
            lastSelectedCategory: lastSelectedCategory,
            delegate: self,
            viewModel: viewModel)
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
        view.backgroundColor = UIColor.projectColor(.white)
        prepareViews()
        setupConstraints()
        setupPlaceholder()
        setupCategoriesTable()
        
        addCategoryButton.addTarget(
            self,
            action: #selector(addCategoryButtonPressed),
            for: .touchUpInside
        )
    }

    private func prepareViews() {
        [titleLabel, addCategoryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Placeholder
    private func setupPlaceholder() {
        view.addSubview(placeholderImage)
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

    private func hidePlaceholder() {
        placeholderImage.removeFromSuperview()
        placeholderText.removeFromSuperview()
    }

    // MARK: - Categories Table
    private func setupCategoriesTable() {
        viewWithCategoryTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewWithCategoryTableView)

        NSLayoutConstraint.activate([
            viewWithCategoryTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            viewWithCategoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewWithCategoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewWithCategoryTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20)
        ])
    }

    // MARK: - Actions
    @objc private func addCategoryButtonPressed() {
        let createVC = CreateCategoryViewController()
        createVC.modalPresentationStyle = .pageSheet
        present(createVC, animated: true)
    }
}

// MARK: - CategoryTableViewDelegateProtocol
extension CategoryPageViewController: CategoryTableViewDelegateProtocol {
    func categoryDidSelected() {
        dismiss(animated: true)
    }
    
    func numberOfLoadedCategoriesStateChanged(isEmpty: Bool) {
        DispatchQueue.main.async {
            if isEmpty {
                self.viewWithCategoryTableView.removeFromSuperview()
                self.setupPlaceholder()
            } else {
                self.hidePlaceholder()
                if self.viewWithCategoryTableView.superview == nil {
                    self.setupCategoriesTable()
                }
            }
        }
    }
}
