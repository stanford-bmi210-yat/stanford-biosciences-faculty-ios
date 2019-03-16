import UIKit

class MainViewController : UITabBarController {
    private let interactor: Interactor
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        
        let facultyViewController = FacultyViewController(interactor: interactor)
        
        tabBar.tintColor = #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        tabBar.barTintColor = #colorLiteral(red: 0.9764705882, green: 0.9647058824, blue: 0.937254902, alpha: 1)
        
        viewControllers = [
            UINavigationController(rootViewController: facultyViewController),
        ]
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
