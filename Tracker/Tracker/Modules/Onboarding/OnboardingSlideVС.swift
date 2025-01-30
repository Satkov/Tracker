import Foundation
import UIKit

final class OnboardingSlideViewController: UIViewController {
    private let pageData: PageData
    private let button = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Localization.onboardingButton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "TrackerBackgroundBlack")
        button.layer.cornerRadius = 16
        return button
    }()

    private let label = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    init(pageNumber: PageData) {
        self.pageData = pageNumber
        super.init(nibName: nil, bundle: nil)
        setupButton()
        setupBackground()
        setupTextField()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        button.addTarget(
            self,
            action: #selector(buttonPressed),
            for: .touchUpInside
        )
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            button.widthAnchor.constraint(equalToConstant: 335),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupBackground() {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: pageData.backgroundImageName)
        backgroundImage.contentMode = .scaleAspectFill

        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
    }

    private func setupTextField() {
        label.text = pageData.labelText
        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304)
        ])
    }

    @objc
    private func buttonPressed() {
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
