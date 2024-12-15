import Foundation

protocol SchedulePageViewControllerDelegateProtocol: AnyObject {
    var selectedDays: Set<Schedule>? { get set }
}
