import UIKit

class FilterButtonManager {
    static let shared = FilterButtonManager()
    private var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.filter, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    var view: FilterPageDelegateProtocol?
    
    private init() {
        setupbutton()
    }
    
    func setupbutton() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        filterButton.frame = CGRect(x: (window.frame.width - 114) / 2,
                                    y: window.frame.height - 150,
                                    width: 114, height: 50)
    }
    
    func showFilterButton() {
        guard let view else { return }
        view.view.addSubview(filterButton)
        view.view.bringSubviewToFront(filterButton)
    }
    
    @objc private func filterButtonTapped() {
        let screenName = view != nil ? NSStringFromClass(type(of: view!)) : "unknown_screen"
        AnalyticsService.shared.logEvent(
            event: "click",
            screen: "Main",
            item: "filter"
        )
        
        guard let view else { return }
        let vc = FiltersPageViewContoller()
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = view
        view.present(vc, animated: true)
    }
    
    
    func removeFilterButton() {
        filterButton.removeFromSuperview()
    }
}
