import UIKit

class SchedulePageViewController: UIViewController {
    private var titleLabel = UILabel()
    private var addScheduleButton = UIButton()
    private var scheduleTable = UITableView()
    
    var selectedDays: Set<Schedule> = []
    weak var delegate: SchedulePageViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupTitleLabel()
        setupAddScheduleButton()
        setupScheduleTableView()
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
    
    @objc
    private func addSelectedDaysButtonPressed() {
        delegate?.selectedDays = selectedDays
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


extension SchedulePageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension SchedulePageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Schedule.allCases.count)
        return Schedule.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = Schedule.allCases[indexPath.row].rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.systemGray6
        cell.selectionStyle = .none
        
        let switchView = UISwitch()
        if selectedDays.contains(Schedule.getDayByNumberWeekday(indexPath.row)) {
            switchView.isOn = true
        } else {
            switchView.isOn = false
        }
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        switchView.onTintColor = UIColor.projectColor(.blue)
        
        cell.accessoryView = switchView
        
        return cell
    }
}
