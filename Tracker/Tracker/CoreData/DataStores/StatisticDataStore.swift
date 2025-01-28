import CoreData
import UIKit

final class StatisticDataStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    func getTotalRecordsCount() -> String? {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.resultType = .countResultType
        do {
            let result = try context.count(for: request)
            return result > 0 ? String(result) : nil
        } catch {
            // TODO: обработка ошибки
            return nil
        }
    }

    func getMaxRecordsPerTracker() -> String? {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RecordCoreData")
        request.resultType = .dictionaryResultType
        
        let countExpression = NSExpressionDescription()
        countExpression.name = "recordCount"
        countExpression.expression = NSExpression(forFunction: "count:", arguments: [NSExpression(forKeyPath: "tracker")])
        countExpression.expressionResultType = .integer32AttributeType

        request.propertiesToFetch = ["tracker", countExpression]
        request.propertiesToGroupBy = ["tracker"]
        
        do {
            if let results = try context.fetch(request) as? [[String: Any]],
               let maxRecords = results.compactMap({ $0["recordCount"] as? Int }).max() {
                return maxRecords > 0 ? String(maxRecords) : nil
            }
        } catch {
            // TODO: обработка ошибки
        }
        return nil
    }
    
    func getAverageRecordsPerDay() -> String? {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RecordCoreData")
        request.resultType = .dictionaryResultType

        let countExpression = NSExpressionDescription()
        countExpression.name = "recordCount"
        countExpression.expression = NSExpression(forFunction: "count:", arguments: [NSExpression(forKeyPath: "date")])
        countExpression.expressionResultType = .integer32AttributeType

        request.propertiesToFetch = ["date", countExpression]
        request.propertiesToGroupBy = ["date"]

        do {
            let results = try context.fetch(request) as? [[String: Any]]
            let totalDays = results?.count ?? 0
            let totalRecords = results?.compactMap({ $0["recordCount"] as? Int }).reduce(0, +) ?? 0

            let value = totalDays > 0 ? Double(totalRecords) / Double(totalDays) : 0.0
            return value > 0 ? String(format: "%.f", value) : nil
        } catch {
            // TODO: обработка ошибки
            return nil
        }
    }
}
