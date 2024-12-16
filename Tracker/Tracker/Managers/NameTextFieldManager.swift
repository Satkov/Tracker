import UIKit

final class NameTextFieldManager: NSObject {
    // MARK: - Properties
    private let trackerNameField: UITextField
    private var delegate: TrackerNameTextFieldManagerDelegateProtocol?
    private var presenter: EditNewTrackerPresenterProtocol?
    private let placeholderText: String

    // MARK: - Initializer
    init(trackerNameField: UITextField, delegate: TrackerNameTextFieldManagerDelegateProtocol?, placeholderText: String, presenter: EditNewTrackerPresenterProtocol?) {
        self.trackerNameField = trackerNameField
        self.delegate = delegate
        self.placeholderText = placeholderText
        self.presenter = presenter
        super.init()
        configureTextField()
    }

    // MARK: - Configuration
    private func configureTextField() {
        trackerNameField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameField.delegate = self
        trackerNameField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerNameField.layer.cornerRadius = 16
        trackerNameField.clearButtonMode = .whileEditing
        trackerNameField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColorForLightgray") ?? .gray]
        )
        trackerNameField.textColor = UIColor(named: "TrackerBackgroundBlack")
        trackerNameField.backgroundColor = UIColor(named: "TrackerBackgroundLightGray")
        setupPadding()
    }

    private func setupPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameField.frame.height))
        trackerNameField.leftView = paddingView
        trackerNameField.leftViewMode = .always
    }
}

// MARK: - UITextFieldDelegate
extension NameTextFieldManager: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text, !name.isEmpty else {
            return
        }
        presenter?.updateName(name: name)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else { return false }

        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        handleCharacterLimit(for: updatedText)
        return updatedText.count <= 38
    }

    private func handleCharacterLimit(for updatedText: String) {
        guard let delegate = delegate else { return }
        
        if updatedText.count > 38 {
            delegate.showWarningLabel()
        } else {
            delegate.hideWarningLabel()
        }
    }
}
