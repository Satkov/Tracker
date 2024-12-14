import Foundation

protocol SchedulePageViewControllerProtocol: AnyObject {
    var selectedDays: Set<Schedule>? { get set }
}
