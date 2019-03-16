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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
                        self.window.rootViewController = MainViewController(interactor: self.interactor)
                    }
                }
            }
        )
    }
}
