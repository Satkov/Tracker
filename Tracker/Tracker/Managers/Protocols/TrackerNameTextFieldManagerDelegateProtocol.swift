import Foundation

protocol TrackerNameTextFieldManagerDelegateProtocol {
    func showWarningLabel()
    func hideWarningLabel()
    var isWarningHidden: Bool { get }
}
