import Foundation
import UIKit

struct TrackerModel: Codable {
    private(set) var id = UUID()
    let name: String
    let color: TrackerColors
    let emoji: Emojis
    let schedule: Set<Schedule>?
}
