import UIKit

final class FiltersPageViewContoller: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        // TODO: localize
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Localization.filters
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let buttonTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.layer.cornerRadius = 16
        table.separatorColor = UIColor.projectColor(.separatorColor)
        return table
    }()

    private let buttonsIdentifiers = [
        Localization.allTrackers,
        Localization.trackersForToday,
        Localization.finished,
        Localization.notFinished
    ]
    var delegate: FilterPageDelegateProtocol?
    var filterSettings: FilterSettings?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.projectColor(.white)
        setupTitleLabel()
        setupTableView()
        buttonTable.delegate = self
        buttonTable.dataSource = self
        buttonTable.rowHeight = 75
        buttonTable.estimatedRowHeight = 75
    }

    private func setupTitleLabel() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    private func setupTableView() {
        view.addSubview(buttonTable)
        buttonTable.register(FilterButtonsTableViewCell.self, forCellReuseIdentifier: "FilterButtonsTableViewCells")

        NSLayoutConstraint.activate([
            buttonTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            buttonTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonTable.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func isCellSelected(for choice: FilterChoice) -> Bool {
        guard let filterSettings else { return false }
        switch choice {
        case .all:
            return filterSettings.recorded == .all &&
                   filterSettings.onlyToday == false
        case .recorded:
            return filterSettings.recorded == .onlyRecorded
        case .unrecorded:
            return filterSettings.recorded == .onlyUnRecorded
        case .today:
            return filterSettings.onlyToday == true
        }
    }
}

extension FiltersPageViewContoller: UITableViewDelegate {
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
        case Localization.allTrackers:
            delegate?.newFilterAdded(filter: .all)
        case Localization.trackersForToday:
            delegate?.newFilterAdded(filter: .today)
        case Localization.finished:
            delegate?.newFilterAdded(filter: .recorded)
        case Localization.notFinished:
            delegate?.newFilterAdded(filter: .unrecorded)
        default:
            break
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension FiltersPageViewContoller: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 4
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FilterButtonsTableViewCells",
            for: indexPath
        ) as? FilterButtonsTableViewCell else { return UITableViewCell() }

        let identifier = buttonsIdentifiers[indexPath.row]

        switch identifier {
        case Localization.allTrackers:
            cell.configureButton(title: identifier, isSelected: isCellSelected(for: .all))
        case Localization.trackersForToday:
            cell.configureButton(title: identifier, isSelected: isCellSelected(for: .today))
        case Localization.finished:
            cell.configureButton(title: identifier, isSelected: isCellSelected(for: .recorded))
        case Localization.notFinished:
            cell.configureButton(title: identifier, isSelected: isCellSelected(for: .unrecorded))

        default:
            break
        }

        cell.selectionStyle = .none
        return cell
    }

}
