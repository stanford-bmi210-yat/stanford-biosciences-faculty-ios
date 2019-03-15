import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let rootViewController = FacultyViewController()
        let rootNavigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        return true
    }
}

