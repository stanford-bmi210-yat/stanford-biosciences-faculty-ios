import UIKit

class RelatedAcademicCollectionViewCell : UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
         imageView.layer.cornerRadius = imageView.bounds.width / 2
    }
}
