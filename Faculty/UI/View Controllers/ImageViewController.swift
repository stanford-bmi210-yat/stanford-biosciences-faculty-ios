import UIKit
import Kingfisher

class ImageViewController : UIViewController {
    private let imageURL: URL
    @IBOutlet private var imageView: UIImageView!
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.kf.setImage(with: imageURL)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ImageViewController {
    @IBAction func closeButtonTouched(_ sender: Any) {
        dismiss(animated: true)
    }
}
