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
    private let filterButton: UIButton = {
        let button = UIButton()
        button.setTitle(Localization.filters, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.trackersTitle
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = Localization.searchPlaceholder
        
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
        label.text = Localization.trackerListPlaceholder
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let addTrackerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "PlusIcon"), for: .normal)
        button.tintColor = UIColor.projectColor(.black)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.backgroundColor = UIColor(hex: "#F0F0F0")
        picker.layer.cornerRadius = 8
        picker.locale = Locale.current
        return picker
    }()
    
    private let trackersCollection = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    private var trackersPresenter: TrackersCollectionPresenter?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupUI()
        setupTrackersCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let date = trackersPresenter?.currentDate {
            updateUI(date: date)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsService.shared.logEvent(
            event: "open",
            screen: "Main",
            item: "screen"
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AnalyticsService.shared.logEvent(
            event: "close",
            screen: "Main",
            item: "screen"
        )

    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(named: "TrackerBackgroundWhite")
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupAddTrackerButton()
        setupHeaderLabel()
        setupSearchBar()
        setupDatePicker()
        setupPlaceholderImage()
        setupPlaceholderText()
        setupGestureRecognizer()
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
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.backgroundColor = .white
        datePicker.layer.cornerRadius = 8
        datePicker.clipsToBounds = true
        if #available(iOS 14.0, *) {
            datePicker.overrideUserInterfaceStyle = .light
        }
        datePicker.subviews.forEach { print($0) }
        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
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
        searchBar.delegate = self
        
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
        trackersCollection.backgroundColor = .clear
        do {
            trackersPresenter = try TrackersCollectionPresenter(
                collectionView: trackersCollection,
                params: params,
                datePicker: datePicker,
                delegate: self
            )
        } catch {
            // TODO: обработка ошибки
        }
        
        trackersCollection.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollection)
        
        NSLayoutConstraint.activate([
            trackersCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: - Actions
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func dateChanged(_ sender: UIDatePicker) {
        let selectedDate = datePicker.date
        trackersPresenter?.updateDate(selectedDate)
        updateUI(date: datePicker.date)
        
    }
    
    @objc
    private func addTrackerButtonPressed() {
        AnalyticsService.shared.logEvent(
            event: "click",
            screen: "Main",
            item: "add_track"
        )
        
        let createTrackerVC = TrackerTypeMenuViewController()
        createTrackerVC.modalPresentationStyle = .pageSheet
        present(createTrackerVC, animated: true)
    }
}

extension TrackerListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        trackersPresenter?.searchBarTextUpdated(text: searchText)
    }
}


extension TrackerListViewController: TrackersCollectionPresenterDelegate {
    func updateUI(date: Date) {
        let hasTrackers = trackersPresenter?.isFilteredTrackersHaveTrackers ?? false
        trackersCollection.isHidden = !hasTrackers
        placeholderImage.isHidden = hasTrackers
        placeholderText.isHidden = hasTrackers
        
        guard let isAnyTrackersForDateExists = trackersPresenter?.isAnyTrackersForChoosenDateExist(date) else { return }
        if !isAnyTrackersForDateExists {
            FilterButtonManager.shared.removeFilterButton()
        } else {
            FilterButtonManager.shared.showFilterButton()
            FilterButtonManager.shared.view = self
        }
    }
}

extension TrackerListViewController: FilterPageDelegateProtocol {
    func newFilterAdded(filter: FilterChoice) {
        trackersPresenter?.applyFilters(filter)
    }
}
