import UIKit

enum PageNumber {
    case first
    case second
    
    func backgroundImage() -> UIImage {
        return UIImage(named: self == .first
                       ? "OnboardingFirst"
                       : "OnboardingSecond") ?? UIImage()
    }
    
    func text() -> String {
        return self == .first
            ? "Отслеживайте только то,\n что хотите"
            : "Даже если это\n не литры воды и йога"
    }
}
