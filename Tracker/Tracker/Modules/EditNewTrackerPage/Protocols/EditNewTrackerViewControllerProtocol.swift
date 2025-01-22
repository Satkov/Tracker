import Foundation

protocol EditNewTrackerViewControllerProtocol: AnyObject {
    var isRegular: Bool { get }
    func setCreateButtonEnable()
    func setCreateButtonDissable()
    func reloadButtonTable()
}
