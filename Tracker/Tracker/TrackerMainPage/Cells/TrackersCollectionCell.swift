import UIKit

final class TrackersCollectionCell: UICollectionViewCell {
    private var cardView = UIView()
    private var footerView = UIView()
    private var emojiLabel = UILabel()
    private var trackerNameLabel = UILabel()
    private var recordLabel = UILabel()
    private var recordButton = UIButton()
    private let recordManager = RecordManager.shared

    // MARK: - Properties
    private var tracker: TrackerModel?
    private var buttonAction: (() -> Void)?
    private var datePicker: UIDatePicker?

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with tracker: TrackerModel, buttonAction: (() -> Void)?, datePicker: UIDatePicker) {
        self.tracker = tracker
        self.buttonAction = buttonAction
        self.datePicker = datePicker
        setupUI()
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

    @objc
    private func recordButtonTapped() {
        buttonAction?()
        setButtonStyle()
    }

    func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 16
        cardView.backgroundColor = tracker?.color.color

        contentView.addSubview(cardView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    func setupFooterView() {
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

    func setupEmojiLabel() {
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.layer.cornerRadius = 12
        emojiLabel.layer.masksToBounds = true
        emojiLabel.backgroundColor = UIColor.projectColor(.backgroundWhite).withAlphaComponent(0.3)
        emojiLabel.text = tracker?.emoji.rawValue

        cardView.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    func setupTrackerNameLabel() {
        trackerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerNameLabel.textAlignment = .left
        trackerNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackerNameLabel.textColor = UIColor.projectColor(.backgroundWhite)
        trackerNameLabel.text = tracker?.name

        cardView.addSubview(trackerNameLabel)

        NSLayoutConstraint.activate([
            trackerNameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            trackerNameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12)
        ])
    }

    func setupRecordButton() {
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.layer.cornerRadius = 16
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        setButtonStyle()

        footerView.addSubview(recordButton)

        NSLayoutConstraint.activate([
            recordButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 8),
            recordButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            recordButton.widthAnchor.constraint(equalToConstant: 34),
            recordButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func setButtonStyle() {
        guard let tracker = tracker,
              let datePicker = datePicker
        else { return }
        if !recordManager.hasRecord(trackerID: tracker.id, date: datePicker.date) {
            recordButton.backgroundColor = tracker.color.color
            recordButton.setImage(UIImage(systemName: "plus"), for: .normal)
            recordButton.tintColor = .white
        } else {
            recordButton.backgroundColor = tracker.color.color.withAlphaComponent(0.3)
            recordButton.setImage(UIImage(named: "Done"), for: .normal)
            recordButton.tintColor = .white
        }
    }

    func setupRecordLabel() {
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        recordLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        if let tracker = tracker {
            let countRecords = recordManager.countRecords(for: tracker.id)
            recordLabel.text = "\(countRecords) дней"
        }
        footerView.addSubview(recordLabel)

        NSLayoutConstraint.activate([
            recordLabel.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            recordLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12),
            recordLabel.trailingAnchor.constraint(equalTo: recordButton.leadingAnchor, constant: -8)
        ])
    }
}
