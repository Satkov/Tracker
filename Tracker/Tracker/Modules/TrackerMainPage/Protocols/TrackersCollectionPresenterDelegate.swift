import UIKit

protocol TrackersCollectionPresenterDelegate: UIViewController {
    func updateUI(date: Date)
    func presentEditTrackerPage(vc: EditTrackerViewController)
}
