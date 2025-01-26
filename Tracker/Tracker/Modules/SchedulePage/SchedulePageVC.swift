import UIKit

final class SchedulePageViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.scheduleTitle
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    private let addScheduleButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.readyButton, for: .normal)
        button.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        button.backgroundColor = UIColor.projectColor(.backgroundBlack)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    private let scheduleTable: UITableView = {
        let tableView = UITableView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.layer.cornerRadius = 16
        return tableView
    }()

    // MARK: - Properties
    private var selectedDays: Set<Schedule>
    private var presenter: EditNewTrackerPresenterProtocol

    init(
        presenter: EditNewTrackerPresenterProtocol,
        selectedDays: Set<Schedule>?
    ) {
        self.presenter = presenter
        self.selectedDays = selectedDays ?? []
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
        prepareViews()
        setupScheduleTableView()
        setupAddScheduleButton()
        setupConstraints()
    }

    private func prepareViews() {
        [titleLabel, scheduleTable, addScheduleButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupScheduleTableView() {
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupAddScheduleButton() {
        addScheduleButton.addTarget(self, action: #selector(addSelectedDaysButtonPressed), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scheduleTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            scheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTable.heightAnchor.constraint(equalToConstant: CGFloat(Schedule.allCases.count) * 75),

            addScheduleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addScheduleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Actions
    @objc
    private func addSelectedDaysButtonPressed() {
        presenter.updateSchedule(new: selectedDays)
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func switchChanged(_ sender: UISwitch) {
        let selectedDay = Schedule.getDayByNumberWeekday(sender.tag)

        if sender.isOn {
            selectedDays.insert(selectedDay)
        } else {
            selectedDays.remove(selectedDay)
        }
    }
}

// MARK: - UITableViewDelegate
extension SchedulePageViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        75
    }
}

// MARK: - UITableViewDataSource
extension SchedulePageViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        Schedule.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell, for: indexPath)
        let isLast = indexPath.row == 6

        if isLast {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.width)
        }

        return cell
    }

    // MARK: - Cell Configuration
    private func configureCell(
        _ cell: UITableViewCell,
        for indexPath: IndexPath
    ) {
        let schedule = Schedule.allCases[indexPath.row]

        cell.textLabel?.text = schedule.rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.backgroundColor = UIColor.systemGray6
        cell.selectionStyle = .none

        let switchView = createSwitch(for: indexPath)
        cell.accessoryView = switchView
    }

    private func createSwitch(
        for indexPath: IndexPath
    ) -> UISwitch {
        let switchView = UISwitch()
        let dayIndex = (indexPath.row + 2) % 7
        switchView.tag = dayIndex == 0 ? 7 : dayIndex
        switchView.isOn = selectedDays.contains(Schedule.getDayByNumberWeekday(switchView.tag))

        switchView.onTintColor = UIColor.projectColor(.blue)
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return switchView
    }
}
