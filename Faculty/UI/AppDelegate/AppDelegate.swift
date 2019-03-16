import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    let interactor = try! Interactor()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        guard let window = self.window else {
            return false
        }
        
        if interactor.academicsCount == 0 {
            window.rootViewController = SetupViewController(window: window, interactor: interactor)
        } else {
            window.rootViewController = MainViewController(interactor: interactor)
        }
        
        window.makeKeyAndVisible()
        return true
    }
}

