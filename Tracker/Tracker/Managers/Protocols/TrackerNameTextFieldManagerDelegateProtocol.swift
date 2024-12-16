import Foundation

protocol TrackerNameTextFieldManagerDelegateProtocol {
    func showWarningLabel() -> Void
    func hideWarningLabel() -> Void
    var isWarningHidden: Bool { get }
}
