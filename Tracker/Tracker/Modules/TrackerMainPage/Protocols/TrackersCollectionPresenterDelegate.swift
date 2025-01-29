import Foundation

protocol TrackersCollectionPresenterDelegate: AnyObject {
    func updateUI()
    func presentEditTrackerPage(vc: EditTrackerViewController)
}
