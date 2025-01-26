import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if hasSeenOnboarding {
            window?.rootViewController = TabBarController()
        } else {
            let onboardingVC = OnboardingPageViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal,
                options: nil
            )
            
            let onboardingPages = [
                OnboardingSlideViewController(
                    pageNumber: PageData(
                        backgroundImageName: "OnboardingFirst",
                        labelText: "Отслеживайте только то,\n что хотите"
                    )
                ),
                OnboardingSlideViewController(
                    pageNumber: PageData(
                        backgroundImageName: "OnboardingSecond",
                        labelText: "Даже если это\n не литры воды и йога"
                    )
                ) 
            ]
            
            onboardingVC.setPages(onboardingPages)
            window?.rootViewController = onboardingVC
            
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}
