import UIKit

final class ViewWithCategoryTableView: UIView {

    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()

    // MARK: - Properties
    private var viewModel: CategoryViewModel?
    private var presenter: EditTrackerPresenterProtocol?
    private weak var delegate: CategoryTableViewDelegateProtocol?

    // MARK: - Initializer
    init(frame: CGRect,
         presenter: EditTrackerPresenterProtocol?
    ) {
        self.presenter = presenter
        super.init(frame: frame)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configurate(
        lastSelectedCategory: TrackerCategoryModel?,
        delegate: CategoryTableViewDelegateProtocol?,
        viewModel: CategoryViewModel
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        viewModel.onNumberOfCategoriesState = { [weak self] isEmpty in
            self?.delegate?.numberOfLoadedCategoriesStateChanged(isEmpty: isEmpty)
            self?.tableView.reloadData()
        }
        viewModel.lastSelectedCategory = lastSelectedCategory
    }

    // MARK: - Setup UI
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self,
                           forCellReuseIdentifier: "CategoryTableViewCell")

        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate
extension ViewWithCategoryTableView: UITableViewDelegate {
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
        guard let viewModel = viewModel else { return }
        viewModel.categorySelected(indexPath: indexPath) { selectedCategory in
            presenter?.updateCategory(new: selectedCategory)
            tableView.reloadData()
            delegate?.categoryDidSelected()
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewWithCategoryTableView: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfCategories()
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let viewModel = viewModel,
            let cell = tableView.dequeueReusableCell(
            withIdentifier: "CategoryTableViewCell",
            for: indexPath
        ) as? CategoryTableViewCell
        else { return UITableViewCell() }

        let dataForCell = viewModel.getDataForCell(indexPath: indexPath)

        cell.configureCell(
            with: dataForCell.categoryName,
            isSelected: dataForCell.isSelected,
            isLast: dataForCell.isLast,
            isFirst: dataForCell.isFirst
        )

        cell.separatorInset = dataForCell.isLast
            ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.width)
            : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        return cell
    }
}
