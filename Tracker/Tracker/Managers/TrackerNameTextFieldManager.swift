import UIKit


class TrackerNameTextFieldManager: NSObject {
    private let trackerNameField: UITextField
    private var delegate: TrackerNameTextFieldManagerDelegateProtocol?
    private var placeholderText: String
    
    init(trackerNameField: UITextField, delegate: TrackerNameTextFieldManagerDelegateProtocol?, placeholderText: String) {
        self.trackerNameField = trackerNameField
        self.delegate = delegate
        self.placeholderText = placeholderText
        super.init()
        configure()
    }
    
    private func configure() {
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
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameField.frame.height)
        )
        trackerNameField.leftView = paddingView
        trackerNameField.leftViewMode = .always
    }
}

extension TrackerNameTextFieldManager: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let delegate = delegate {
            let currentText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count <= 38 {
                if !delegate.isWarningHidden {
                    delegate.hideWarningLabel()
                }
                return true
            } else {
                if delegate.isWarningHidden {
                    delegate.showWarningLabel()
                }
                return false
            }
        }
        return true
    }
}
