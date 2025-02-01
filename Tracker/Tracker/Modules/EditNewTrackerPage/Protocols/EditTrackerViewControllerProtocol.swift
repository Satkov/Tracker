import Foundation

protocol EditTrackerViewControllerProtocol: AnyObject {
    var isRegular: Bool { get }
    func setCreateButtonEnable()
    func setCreateButtonDissable()
    func reloadButtonTable()
}
