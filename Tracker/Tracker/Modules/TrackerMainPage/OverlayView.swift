import UIKit

class OverlayView {
    static let shared = OverlayView()
    private var filterButton: UIButton?
    var view: FilterPageDelegateProtocol?
    
    func showFilterButton() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        if filterButton != nil { return }
        
        let button = UIButton(type: .system)
        button.setTitle("Фильтр", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.frame = CGRect(x: (window.frame.width - 114) / 2,
                              y: window.frame.height - 150,
                              width: 114, height: 50)
        
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        window.addSubview(button)
        window.bringSubviewToFront(button)
        self.filterButton = button
    }
    
    @objc private func filterButtonTapped() {
        guard let view else { return }
        let vc = FiltersPageViewContoller()
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = view
        view.present(vc, animated: true)
    }
    
    
    func removeFilterButton() {
        guard let button = filterButton else { return }
        button.removeFromSuperview()
        filterButton = nil
    }
    
    func isButtonVisible() -> Bool {
        return filterButton != nil
    }
}
