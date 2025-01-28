import Foundation

struct TrackersFilters {
    static func movePinnedToCompleted(in categories: inout [TrackerCategoryModel]) {
        var completedTrackers: [TrackerModel] = []
        
        // Проходим по категориям и собираем закрепленные трекеры
        categories = categories.compactMap { category in
            let (pinned, unpinned) = category.trackers.partitioned { $0.isPinned }
            
            completedTrackers.append(contentsOf: pinned)
            
            return unpinned.isEmpty ? nil : TrackerCategoryModel(
                categoryName: category.categoryName,
                trackers: unpinned
            )
        }
        
        // Если есть закрепленные трекеры, создаем категорию "Завершенные"
        if !completedTrackers.isEmpty {
            let completedCategory = TrackerCategoryModel(
                categoryName: "Закрепленные",
                trackers: completedTrackers.sorted { $0.name < $1.name }
            )
            categories.insert(completedCategory, at: 0) // Добавляем в начало списка
        }
    }
    
    static func filterAndSortCategories(by searchText: String, in categories: inout [TrackerCategoryModel]) {
        guard searchText != "" else { return }
        categories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.name.lowercased().contains(searchText.lowercased())
            }.sorted { $0.name < $1.name }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategoryModel(
                categoryName: category.categoryName,
                trackers: filteredTrackers
            )
        }
    }
    
    static func filterByRecordStatus(
        in categories: inout [TrackerCategoryModel],
        status: RecordStatus,
        date: Date,
        recordsDataStore: RecordsDataStore
    ) {
        categories = categories.compactMap { category in
            let filteredTrackers = category.trackers.filter { tracker in
                let hasRecord = recordsDataStore.hasRecord(trackerID: tracker.id, date: date)
                
                switch status {
                case .onlyRecorded:
                    return hasRecord
                case .onlyunrecorded:
                    return !hasRecord
                case .all:
                    return true
                }
            }
            
            return filteredTrackers.isEmpty ? nil : TrackerCategoryModel(
                categoryName: category.categoryName,
                trackers: filteredTrackers
            )
        }
    }
}

struct FilterSettings {
    var date: Date
    var trackerName: String
    var recorded: RecordStatus
}


enum RecordStatus {
    case onlyRecorded
    case onlyunrecorded
    case all
}

extension Array {
    func partitioned(by predicate: (Element) -> Bool) -> (matching: [Element], nonMatching: [Element]) {
        var matching: [Element] = []
        var nonMatching: [Element] = []
        for element in self {
            if predicate(element) {
                matching.append(element)
            } else {
                nonMatching.append(element)
            }
        }
        return (matching, nonMatching)
    }
}
