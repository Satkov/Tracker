import UIKit

class StatisticTableView: UIView {
    let tableView = {
        let tableView = UITableView()

        return tableView
    }()

    let dataProvider = StatisticDataProvider()

    func configurate() {
        setupTableView()
        tableView.reloadData()
        self.backgroundColor = .clear
        tableView.backgroundColor = .clear
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: "statisticTableCell")
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension StatisticTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

}

extension StatisticTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        StatisticType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "statisticTableCell",
                for: indexPath
            ) as? StatisticTableViewCell else { return UITableViewCell() }

        let type = StatisticType.allCases[indexPath.section]
        let value = dataProvider.getStatistic(type: type)
        cell.configurate(type: type, value: value)
        return cell
        }

}
