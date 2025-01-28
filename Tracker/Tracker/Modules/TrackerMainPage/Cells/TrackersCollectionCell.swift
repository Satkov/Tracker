import UIKit

final class TrackersCollectionCell: UICollectionViewCell {
    // MARK: - UI Elements
    private let cardView = UIView()
    private let footerView = UIView()
    private let emojiLabel = UILabel()
    private let trackerNameLabel = UILabel()
    private let recordLabel = UILabel()
    private let recordButton = UIButton()

    // MARK: - Properties
    private var tracker: TrackerModel?
    private var datePicker: UIDatePicker?
    private var recordsDataProvider: RecordsDataProvider?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(
        with tracker: TrackerModel,
        datePicker: UIDatePicker
    ) {
        self.tracker = tracker
        self.datePicker = datePicker
        setupUI()
        
        recordsDataProvider?.delegate = nil
        recordsDataProvider = RecordsDataProvider(
            trackerID: tracker.id,
            context: CoreDataManager.shared.context,
            delegate: self
        )
        updateRecordCount()
        updateButtonStyle()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        recordsDataProvider?.delegate = nil
        tracker = nil
        datePicker = nil
        recordsDataProvider = nil
    }

    // MARK: - Setup UI
    private func setupUI() {
        setupCardView()
        setupFooterView()
        setupEmojiLabel()
        setupTrackerNameLabel()
        setupRecordButton()
        setupRecordLabel()
    }

    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 16
        cardView.backgroundColor = tracker?.color.getUIColor()

        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    private func setupFooterView() {
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .clear

        contentView.addSubview(footerView)

        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 58)
        ])
    }

    private func setupEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        emojiLabel.backgroundColor = UIColor.projectColor(.white).withAlphaComponent(0.3)
        emojiLabel.text = tracker?.emoji.rawValue

        cardView.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupTrackerNameLabel() {
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLabel.textAlignment = .left
        trackerNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackerNameLabel.textColor = UIColor.projectColor(.white)
        trackerNameLabel.text = tracker?.name

        cardView.addSubview(trackerNameLabel)

        NSLayoutConstraint.activate([
            trackerNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])
    }

    private func setupRecordButton() {
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.layer.cornerRadius = 16
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(recordButton)

        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            recordButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            recordButton.widthAnchor.constraint(equalToConstant: 34),
            recordButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func setupRecordLabel() {
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        recordLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        // TODO: localize
        let localizedString = String.localizedStringWithFormat(
            NSLocalizedString("daysCount", comment: ""),
            0
        )
        recordLabel.text = localizedString

        footerView.addSubview(recordLabel)

        NSLayoutConstraint.activate([
            recordLabel.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            recordLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12),
            recordLabel.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -8)
        ])
    }

    // MARK: - Button Action
    @objc
    private func recordButtonTapped() {
        guard let date = datePicker?.date, date <= Date() else { return }
        recordsDataProvider?.toggleRecord(for: date)
    }
    
    private func updateButtonStyle() {
        guard let tracker = tracker, let datePicker = datePicker else { return }
        
        let hasRecord = recordsDataProvider?.hasRecord(for: datePicker.date) ?? false
        if !hasRecord {
            recordButton.backgroundColor = tracker.color.getUIColor()
            recordButton.setImage(UIImage(systemName: "plus"), for: .normal)
            recordButton.tintColor = .white
        } else {
            recordButton.backgroundColor = tracker.color.getUIColor().withAlphaComponent(0.3)
            recordButton.setImage(UIImage(named: "Done"), for: .normal)
            recordButton.tintColor = .white
        }
    }

    // MARK: - UI Updates
    private func updateRecordCount() {
        let countRecords = recordsDataProvider?.recordCount ?? 0
        // TODO: Localize
        let localizedString = String.localizedStringWithFormat(
            NSLocalizedString("daysCount", comment: ""),
            countRecords
        )
        recordLabel.text = localizedString
    }
}

extension TrackersCollectionCell: RecordsDataProviderDelegate {
    func recordsDidUpdate(for trackerID: UUID) {
        guard trackerID == tracker?.id else { return }
        DispatchQueue.main.async {
            self.updateRecordCount()
            self.updateButtonStyle()
        }
    }
}
