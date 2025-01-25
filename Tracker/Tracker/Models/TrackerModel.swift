import Foundation
import UIKit

struct TrackerModel {
    let id: UUID
    let name: String
    let color: TrackerColors
    let emoji: Emojis
    let schedule: Set<Schedule>?
}
