import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarControllers()
        addTopBorderToTabBar()
    }
    
    private func addTopBorderToTabBar() {
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 1)
        
        tabBar.layer.addSublayer(topBorder)
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
