import UIKit

final class OnboardingPageViewController: UIPageViewController {
    private var pages: [UIViewController] = []

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = .brown
        pageControl.pageIndicatorTintColor = .orange

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    func setPages(_ pages: [UIViewController]) {
        self.pages = pages
    }

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
        setupPageControl()
    }

    private func setupPageControl() {
        guard let superview = view.superview else { return }
        let pageControlColor = UIColor.projectColor(.black)
        pageControl.pageIndicatorTintColor = pageControlColor.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = pageControlColor
        superview.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -168)
        ])
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
