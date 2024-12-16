import UIKit

final class SchedulePageViewController: UIViewController {
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let addScheduleButton = UIButton()
    private let scheduleTable = UITableView()

    // MARK: - Properties
    var selectedDays: Set<Schedule> = []
    var presenter: EditNewTrackerPresenterProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupTitleLabel()
        setupScheduleTableView()
        setupAddScheduleButton()
    }

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Расписание"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textAlignment = .center

        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupScheduleTableView() {
        scheduleTable.translatesAutoresizingMaskIntoConstraints = false
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        scheduleTable.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        scheduleTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        scheduleTable.layer.cornerRadius = 16

        view.addSubview(scheduleTable)

        NSLayoutConstraint.activate([
            scheduleTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            scheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTable.heightAnchor.constraint(equalToConstant: CGFloat(Schedule.allCases.count) * 75)
        ])
    }

    private func setupAddScheduleButton() {
        addScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        addScheduleButton.setTitle("Готово", for: .normal)
        addScheduleButton.setTitleColor(UIColor.projectColor(.backgroundWhite), for: .normal)
        addScheduleButton.backgroundColor = UIColor.projectColor(.backgroundBlack)
        addScheduleButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addScheduleButton.layer.cornerRadius = 16
        addScheduleButton.addTarget(self, action: #selector(addSelectedDaysButtonPressed), for: .touchUpInside)

        view.addSubview(addScheduleButton)

        NSLayoutConstraint.activate([
            addScheduleButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addScheduleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    // MARK: - Actions
    @objc
    private func addSelectedDaysButtonPressed() {
        presenter?.updateSchedule(new: selectedDays)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
}

// MARK: - UITableViewDataSource
extension SchedulePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Schedule.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell, for: indexPath)
        return cell
    }

    // MARK: - Cell Configuration
    private func configureCell(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let schedule = Schedule.allCases[indexPath.row]

        cell.textLabel?.text = schedule.rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.backgroundColor = UIColor.systemGray6
        cell.selectionStyle = .none

        let switchView = createSwitch(for: indexPath)
        cell.accessoryView = switchView
    }

    private func createSwitch(for indexPath: IndexPath) -> UISwitch {
        let switchView = UISwitch()
        switchView.tag = indexPath.row
        switchView.isOn = selectedDays.contains(Schedule.getDayByNumberWeekday(indexPath.row))
        switchView.onTintColor = UIColor.projectColor(.blue)
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return switchView
    }
}
