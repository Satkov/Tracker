import Foundation

protocol TrackersDataProviderProtocol {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(_ section: Int) -> Int
    func trackerObject(at indexPath: IndexPath) -> TrackerModel?
    func addTracker(to categoryName: String, trackerModel: TrackerModel) throws
    func deleteTracker(at indexPath: IndexPath) throws
}
