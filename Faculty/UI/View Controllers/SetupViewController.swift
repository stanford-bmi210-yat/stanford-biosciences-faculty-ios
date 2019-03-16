import UIKit

class SetupViewController: UIViewController {
    private let window: UIWindow
    private let interactor: Interactor
    
    @IBOutlet var progressView: UIProgressView!
    
    init(window: UIWindow, interactor: Interactor) {
        self.window = window
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactor.queryAllAcademics(
            progress: { progress in
                DispatchQueue.main.async {
                    self.progressView.progress = progress
                }
            },
            result: { academics, error in
                DispatchQueue.main.async {
                    self.alertErrorOnFailure {
                        if let error = error {
                            throw error
                        }
                        
                        guard let academics = academics else {
                            fatalError("Unexpected")
                        }
                        
                        try self.interactor.add(academics: academics)
                        self.presentMainView()
                    }
                }
            }
        )
    }
    
    private func presentMainView() {
        let facultyViewController = FacultyViewController(interactor: interactor)
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        tabBarController.tabBar.barTintColor = #colorLiteral(red: 0.9764705882, green: 0.9647058824, blue: 0.937254902, alpha: 1)
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: facultyViewController),
        ]
        
        window.rootViewController = tabBarController
    }
}
