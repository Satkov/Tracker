import Foundation

protocol RecordsDataProviderDelegate: AnyObject {
    func recordsDidUpdate(for trackerID: UUID)
}
