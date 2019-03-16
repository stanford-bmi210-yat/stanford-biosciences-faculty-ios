import UIKit

@IBDesignable
class ProfilePictureImageView : UIImageView {
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}
