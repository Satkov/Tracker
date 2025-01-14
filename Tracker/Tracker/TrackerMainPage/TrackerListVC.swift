import UIKit

final class TrackerListViewController: UIViewController, UIViewControllerTransitioningDelegate {
    // MARK: - Constants
    private let params: GeometricParamsModel

    // MARK: - UI Elements
    private let headerLabel = UILabel()
    private let searchBar = UISearchBar()
    private let placeholderImage = UIImageView()
    private let placeholderText = UILabel()
    private let addTrackerButton = UIButton(type: .system)
    private let datePicker = UIDatePicker()
    private let trackersCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: - Properties
    private var trackersCollectionManager: TrackersCollectionManager?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        showTrackerPlaceholder()
        setupTrackersCollectionView()
    }

    // MARK: - Initializer

    init() {
        self.params = GeometricParamsModel(
            cellCount: 2,
            leftInset: 16,
            rightInset: 16,
            cellSpacing: 9,
            cellWidth: 167,
            cellHeight: 148
        )
        super.init(nibName: nil, bundle: nil)
//        self.presenter =
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        setupAddTrackerButton()
        setupHeaderLabel()
        setupSearchBar()
        setupDatePicker()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupAddTrackerButton() {
        addTrackerButton.setImage(UIImage(named: "PlusIcon"), for: .normal)
        addTrackerButton.tintColor = UIColor.projectColor(.backgroundBlack)
        addTrackerButton.addTarget(self, action: #selector(addTrackerButtonPressed), for: .touchUpInside)
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addTrackerButton)

        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func setupDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor(hex: "#F0F0F0")
        datePicker.layer.cornerRadius = 8
        datePicker.locale = Locale(identifier: "ru_RU")

        view.addSubview(datePicker)

        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        trackersCollectionManager?.updateCategories()
        trackersCollection.reloadData()
    }

    private func setupHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Трекеры"
        headerLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)

        view.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1)
        ])
    }

    private func setupSearchBar() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"

        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.layer.cornerRadius = 10
            textField.layer.masksToBounds = true
            textField.leftView = UIImageView(image: UIImage(named: "SearchBarIcon"))
            textField.leftViewMode = .always
        }

        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 7),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func showTrackerPlaceholder() {
        setupPlaceholderImage()
        setupPlaceholderText()
    }

    private func setupPlaceholderImage() {
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.image = UIImage(named: "StarPlaceholder")

        view.addSubview(placeholderImage)

        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220)
        ])
    }

    private func setupPlaceholderText() {
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.text = "Что будем отслеживать?"
        placeholderText.font = UIFont.systemFont(ofSize: 12, weight: .medium)

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
            trackersCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc
    private func addTrackerButtonPressed() {
        let createTrackerVC = TrackerTypeMenuViewController()
        createTrackerVC.onTrackerCreation = { [weak self] in
            guard let self = self else { return }
            self.trackersCollectionManager?.updateCategories()
            self.trackersCollection.reloadData()
            print("LOG: asd")
        }
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(createTrackerVC, animated: true)
    }
}
