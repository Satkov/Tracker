import Foundation

protocol CategoryTableViewDelegateProtocol: NSObject {
    func categoryDidSelected()
    func numberOfLoadedCategoriesStateChanged(isEmpty: Bool)
}
