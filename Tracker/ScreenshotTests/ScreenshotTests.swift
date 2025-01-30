import XCTest
import SnapshotTesting
@testable import Tracker

final class ScreenshotTests: XCTestCase {

    func testViewController() {
        let vc = TrackerListViewController()

        assertSnapshot(of: vc, as: .image)
    }

}
