import UIKit


class TrackerTypeMenuViewController: UIViewController {
    private var habbitTrackerButton = UIButton()
    private var unregularTrackerButton = UIButton()
    private var titleLabel = UILabel()
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupHabbitTrackerButton()
        setupUnregularTrackerButton()
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Создание трекера"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        ])
    }
    
    private func setupButtonUI(for button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "TrackerBackgroundBlack")
        button.layer.cornerRadius = 16
    }
    
    private func setupHabbitTrackerButton() {
        habbitTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        setupButtonUI(for: habbitTrackerButton, title: "Привычка")
        habbitTrackerButton.addTarget(nil, action: #selector(habbitButtonPressed), for: .touchUpInside)
        view.addSubview(habbitTrackerButton)
        
        NSLayoutConstraint.activate([
            habbitTrackerButton.widthAnchor.constraint(equalToConstant: 335),
            habbitTrackerButton.heightAnchor.constraint(equalToConstant: 60),
            habbitTrackerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habbitTrackerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupUnregularTrackerButton() {
        unregularTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        setupButtonUI(for: unregularTrackerButton, title: "Нерегулярное событие")
        unregularTrackerButton.addTarget(nil, action: #selector(unregularTrackerButtonPressed), for: .touchUpInside)
        view.addSubview(unregularTrackerButton)
        
        NSLayoutConstraint.activate([
            unregularTrackerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unregularTrackerButton.topAnchor.constraint(equalTo: habbitTrackerButton.bottomAnchor, constant: 16),
            unregularTrackerButton.widthAnchor.constraint(equalToConstant: 335),
            unregularTrackerButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func switchToEditTrackerForm(isRegular: Bool) {
        let editVC = EditNewTrackerViewController(type: isRegular)
        editVC.modalPresentationStyle = .pageSheet
        present(editVC, animated: true)
    }

    
    @objc
    func habbitButtonPressed() {
        switchToEditTrackerForm(isRegular: true)
    }
    
    @objc
    func unregularTrackerButtonPressed() {
        switchToEditTrackerForm(isRegular: false)
    }
}
