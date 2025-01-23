import Foundation

@objc(ScheduleTransformer)
final class ScheduleTransformer: ValueTransformer {

    override func transformedValue(_ value: Any?) -> Any? {
        guard let scheduleSet = value as? Set<Schedule> else { return nil }
        let scheduleArray = Array(scheduleSet)
        return try? JSONEncoder().encode(scheduleArray)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        guard let scheduleArray = try? JSONDecoder().decode([Schedule].self, from: data) else { return nil }
        return Set(scheduleArray)
    }

    static func register() {
        let transformer = ScheduleTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: NSValueTransformerName(rawValue: "ScheduleTransformer"))
    }
}
