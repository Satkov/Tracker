import UIKit

final class OnboardingPageViewController: UIPageViewController {
    private let pages = [
        OnboardingSlideViewController(pageNumber: .first),
        OnboardingSlideViewController(pageNumber: .second)
    ]
    
    private let button = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "TrackerBackgroundBlack")
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .brown
        pageControl.pageIndicatorTintColor = .orange
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let first = pages.first {
            setViewControllers([first],
                               direction: .forward,
                               animated: true)
        }
        delegate = self
        dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupButton()
        setupPageControl()
    }
    
    func setupButton() {
        guard let superview = view.superview else { return }
        button.addTarget(
            self,
            action: #selector(buttonPressed),
            for: .touchUpInside
        )
        superview.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.widthAnchor.constraint(equalToConstant: 335),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupPageControl() {
        guard let superview = view.superview else { return }
        let pageControlColor = UIColor(hex: "#1A1B22")
        pageControl.pageIndicatorTintColor = pageControlColor.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = pageControlColor
        superview.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168)
        ])
    }
    
    @objc
    func buttonPressed() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        guard let window = UIApplication.shared.windows.first else { return }
        
        let newRootVC = TabBarController()
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = newRootVC
            }
        )
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController as! OnboardingSlideViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnboardingSlideViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController as! OnboardingSlideViewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    
}
