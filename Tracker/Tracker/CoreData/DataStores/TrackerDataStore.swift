import CoreData

// MARK: - DataStore
final class TrackerDataStore {
    
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
    }
    
    init() {
        self.context = CoreDataManager.shared.context
    }
    
    private func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
    
    func fetchCategoriesWithTrackers(for date: Date) throws -> [TrackerCategoryModel] {
        return try performSync { context in
            Result {
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                let allTrackers = try context.fetch(request)
                
                let scheduleDay = Schedule.dayOfWeek(for: date)
                var categoryMap: [(categoryID: NSManagedObjectID, name: String, trackers: [TrackerModel])] = []
                
                var categoryDict: [NSManagedObjectID: (name: String, trackers: [TrackerModel])] = [:]
                
                for trackerCoreData in allTrackers {
                    guard let category = trackerCoreData.category,
                          let categoryName = category.name,
                          let scheduleData = trackerCoreData.schedule,
                          let schedule = try? JSONDecoder().decode(Set<Schedule>.self, from: scheduleData),
                          schedule.contains(scheduleDay) else { continue }
                    
                    let trackerModel = TrackerModel(
                        id: trackerCoreData.id ?? UUID(),
                        name: trackerCoreData.name ?? "",
                        color: TrackerColors(rawValue: trackerCoreData.color ?? "") ?? .red,
                        emoji: Emojis(rawValue: trackerCoreData.emoji ?? "") ?? .smilingFace,
                        schedule: schedule,
                        isPinned: trackerCoreData.isPinned
                    )
                    
                    categoryDict[category.objectID, default: (name: categoryName, trackers: [])].trackers.append(trackerModel)
                }
                
                categoryMap = categoryDict.map { (key, value) in
                    (categoryID: key, name: value.name, trackers: value.trackers)
                }
                
                return categoryMap
                    .sorted { $0.categoryID.uriRepresentation().absoluteString < $1.categoryID.uriRepresentation().absoluteString }
                    .map { category in
                        TrackerCategoryModel(
                            categoryName: category.name,
                            trackers: category.trackers.sorted { $0.id.uuidString < $1.id.uuidString }
                        )
                    }
            }
        }
    }
    
    func togglePin(for tracker: TrackerModel) throws {
        try performSync { context in
            Result {
                let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
                
                guard let trackerCoreData = try context.fetch(request).first else {
                    // TODO: обработка ошибки
                    return
                }
                
                trackerCoreData.isPinned.toggle()
                
                try context.save()
            }
        }
        
    }
}

// MARK: - NotepadDataStore
extension TrackerDataStore: TrackerDataStoreProtocol {
    func add(tracker: TrackerModel, categoryName: String) throws {
        try performSync { context in
            Result {
                let request: NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
                request.predicate = NSPredicate(format: "name = %@", categoryName)
                
                guard let categoryCoreData = try context.fetch(request).first else { return }
                
                let trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.id = tracker.id
                trackerCoreData.name = tracker.name
                trackerCoreData.color = tracker.color.rawValue
                trackerCoreData.emoji = tracker.emoji.rawValue
                
                if let schedule = tracker.schedule, let scheduleData = try? JSONEncoder().encode(schedule) {
                    trackerCoreData.schedule = scheduleData
                } else {
                    trackerCoreData.schedule = nil
                }
                
                categoryCoreData.mutableSetValue(forKey: "trackers").add(trackerCoreData)
                
                CoreDataManager.shared.saveContext()
            }
        }
    }
    
    
    func delete(_ tracker: NSManagedObject) throws {
        try performSync { context in
            Result {
                let objectInContext = context.object(with: tracker.objectID)
                context.delete(objectInContext)
                try context.save()
            }
        }
    }
}
