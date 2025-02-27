import UIKit

protocol FilterPageDelegateProtocol: UIViewController {
    func newFilterAdded(filter: FilterChoice)
    func getFilterSettings() -> FilterSettings?
}
