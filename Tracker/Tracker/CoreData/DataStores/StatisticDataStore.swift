import CoreData
import UIKit

final class StatisticDataStore {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.context) {
        self.context = context
    }

    /// Возвращает общее количество записей в Core Data
    func getTotalRecordsCount() -> String {
        let request: NSFetchRequest<RecordCoreData> = RecordCoreData.fetchRequest()
        request.resultType = .countResultType
        do {
            let result = try context.count(for: request)
            return String(result)
        } catch {
            print("Ошибка при получении общего количества записей: \(error.localizedDescription)")
            return "0"
        }
    }

    /// Возвращает максимальное количество записей для одного трекера
    func getMaxRecordsPerTracker() -> String {
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
                return String(maxRecords)
            }
        } catch {
            print("Ошибка при получении максимального количества записей на трекер: \(error.localizedDescription)")
        }
        return "0"
    }
    
    func getAverageRecordsPerDay() -> String {
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
            return String(format: "%.2f", value)
        } catch {
            print("Ошибка при расчете среднего количества выполненных привычек за день: \(error.localizedDescription)")
            return "0"
        }
    }
}
