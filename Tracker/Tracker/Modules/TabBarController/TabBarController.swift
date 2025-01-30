import UIKit

final class TabBarController: UITabBarController {
    private let topBorder = CALayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarControllers()
        updateTabBarBorder()
    }

    private func updateTabBarBorder() {
        if traitCollection.userInterfaceStyle == .dark {
            topBorder.removeFromSuperlayer()
        } else {
            topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.bounds.width, height: 0.5)
            topBorder.backgroundColor = UIColor.lightGray.cgColor
            tabBar.layer.addSublayer(topBorder)
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTabBarBorder()
    }

    private func setupTabBarControllers() {
        let trackerViewController = TrackerListViewController()
        let trackerNavViewController = UINavigationController(rootViewController: trackerViewController)

        let statisticViewController = StatisticPageViewController()
        statisticViewController.tabBarItem = UITabBarItem(
            title: Localization.statisticTitle,
            image: UIImage(named: "RabbitIcon"),
            selectedImage: nil
        )

        trackerNavViewController.tabBarItem = UITabBarItem(
            title: Localization.trackersTitle,
            image: UIImage(named: "TrackerCircleIcon"),
            selectedImage: nil
        )

        viewControllers = [trackerNavViewController, statisticViewController]
    }
}
