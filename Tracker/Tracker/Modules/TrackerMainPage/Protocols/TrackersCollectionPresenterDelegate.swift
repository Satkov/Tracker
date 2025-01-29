import UIKit

protocol TrackersCollectionPresenterDelegate: UIViewController {
    func updateUI()
    func presentEditTrackerPage(vc: EditTrackerViewController)
}
