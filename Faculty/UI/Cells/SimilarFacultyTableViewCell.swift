import UIKit

class SimilarFacultyTableViewCell : UITableViewCell {
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "RelatedAcademicCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
}
