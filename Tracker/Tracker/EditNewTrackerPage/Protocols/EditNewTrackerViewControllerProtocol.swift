import Foundation

protocol EditNewTrackerViewControllerProtocol {
    var isRegular: Bool { get }
    func setCreateButtonEnable()
    func setCreateButtonDissable()
    func reloadButtonTable()
}
