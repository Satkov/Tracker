import UIKit

protocol ViewWithTableViewProtocol: UIView {
    var delegate: CategoryTableViewDelegateProtocol? { get set }
    func initialize(presenter: EditNewTrackerPresenterProtocol)
}
