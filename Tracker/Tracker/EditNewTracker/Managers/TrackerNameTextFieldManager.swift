import UIKit


class TrackerNameTextFieldManager: NSObject {
    private let trackerNameField: UITextField
    private let clearButton = UIButton(type: .system)
    
    init(trackerNameField: UITextField) {
        self.trackerNameField = trackerNameField
        super.init()
        configure()
    }
    
    private func configure() {
        trackerNameField.translatesAutoresizingMaskIntoConstraints = false
        trackerNameField.delegate = self
        trackerNameField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerNameField.layer.cornerRadius = 16
        trackerNameField.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColorForLightgray") ?? .gray]
        )
        trackerNameField.textColor = UIColor(named: "TrackerBackgroundBlack")
        trackerNameField.backgroundColor = UIColor(named: "TrackerBackgroundLightGray")
        setupPadding()
        setupClearButton()
    }
    
    private func setupPadding() {
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameField.frame.height)
        )
        trackerNameField.leftView = paddingView
        trackerNameField.leftViewMode = .always
        
        let rightPaddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: 16, height: trackerNameField.frame.height)
        )
        trackerNameField.rightView = rightPaddingView
        trackerNameField.rightViewMode = .always
    }
    
    private func setupClearButton() {
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .gray
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        trackerNameField.rightView = clearButton
        trackerNameField.rightViewMode = .always
        
        
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 17),
            clearButton.heightAnchor.constraint(equalToConstant: 17),
            clearButton.trailingAnchor.constraint(equalTo: trackerNameField.trailingAnchor, constant: -28),
            clearButton.centerYAnchor.constraint(equalTo: trackerNameField.centerYAnchor)
        ])
        
        clearButton.isHidden = true
    }
    
    @objc
    func clearText() {
        trackerNameField.text = ""
    }
    
    private func updateClearButtonVisability() {
        if trackerNameField.text != "" {
            clearButton.isHidden = false
            clearButton.isEnabled = true
        } else {
            clearButton.isHidden = true
        }
    }
    
    
}

extension TrackerNameTextFieldManager: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count <= 38 {
            return true
        } else {
            // TODO: Показ предупреждения
            return false
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateClearButtonVisability()
    }
}

