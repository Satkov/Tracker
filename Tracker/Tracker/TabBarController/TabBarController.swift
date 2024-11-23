import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
            super.viewDidLoad()
            setupTabBarControllers()
        }
    
    
    private func setupTabBarControllers() {
        let trackerViewController = TrackerViewController()
        let trackerNavViewController = UINavigationController(rootViewController: trackerViewController)
        
        let statisticViewController = StatisticViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "RabbitIcon"),
            selectedImage: nil)
        
        
        trackerNavViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "TrackerCircleIcon"),
            selectedImage: nil
        )
        
        
        
        viewControllers = [trackerNavViewController, statisticViewController]
    }
}
