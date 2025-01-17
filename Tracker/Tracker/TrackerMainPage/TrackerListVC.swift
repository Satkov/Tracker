import UIKit

final class TrackerListViewController: UIViewController, UIViewControllerTransitioningDelegate {
    // MARK: - Constants
    private let params = GeometricParamsModel(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9,
        cellWidth: 167,
        cellHeight: 148
    )

    // MARK: - UI Elements
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            textField.leftView = UIImageView(image: UIImage(named: "SearchBarIcon"))
            textField.leftViewMode = .always
        }
        return searchBar
    }()

    private let placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StarPlaceholder")
        return imageView
    }()

    private let placeholderText: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()

    private let addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "PlusIcon"), for: .normal)
        button.tintColor = UIColor.projectColor(.backgroundBlack)
        return button
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.backgroundColor = UIColor(hex: "#F0F0F0")
        picker.layer.cornerRadius = 8
        picker.locale = Locale(identifier: "ru_RU")
        return picker
    }()

    private let trackersCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Properties
    private var trackersCollectionManager: TrackersCollectionManager?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTrackersCollectionView()
        updateUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupAddTrackerButton()
        setupHeaderLabel()
        setupSearchBar()
        setupDatePicker()
        setupPlaceholderImage()
        setupPlaceholderText()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupAddTrackerButton() {
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addTrackerButton)
        
        addTrackerButton.addTarget(self, action: #selector(addTrackerButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        trackersCollectionManager?.updateCategories()
        updateUI()
    }

    private func setupHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1)
        ])
    }

    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 7),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupPlaceholderImage() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderImage)

        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220)
        ])
    }

    private func setupPlaceholderText() {
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderText)

        NSLayoutConstraint.activate([
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8)
        ])
    }

    private func setupTrackersCollectionView() {
        trackersCollectionManager = TrackersCollectionManager(collectionView: trackersCollection,
                                                              params: params,
                                                              datePicker: datePicker)
        view.addSubview(trackersCollection)

        NSLayoutConstraint.activate([
            trackersCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateUI() {
        let selectedDay = Schedule.dayOfWeek(for: datePicker.date)
        let hasTrackers = TrackerCategoryManager.shared.hasAnyTrackers(for: selectedDay)
        trackersCollection.isHidden = !hasTrackers
        placeholderImage.isHidden = hasTrackers
        placeholderText.isHidden = hasTrackers
        trackersCollection.reloadData()
    }

    // MARK: - Actions
    @objc
    private func addTrackerButtonPressed() {
        let createTrackerVC = TrackerTypeMenuViewController()
        createTrackerVC.onTrackerCreation = { [weak self] in
            guard let self else { return }
            self.trackersCollectionManager?.updateCategories()
            self.updateUI()
        }
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(createTrackerVC, animated: true)
    }
}
