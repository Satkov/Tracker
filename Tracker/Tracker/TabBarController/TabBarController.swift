import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
            super.viewDidLoad()
            setupTabBarControllers()
        }
    
    
    private func setupTabBarControllers() {
        let trackerViewController = TrackerViewController()
        let trackerNavViewController = UINavigationController(rootViewController: trackerViewController)
        trackerNavViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackerCircleIcon"),
            selectedImage: nil
        )
        
        viewControllers = [trackerNavViewController]
    }
}
