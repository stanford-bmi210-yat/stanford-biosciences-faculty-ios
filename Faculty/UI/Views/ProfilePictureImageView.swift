import UIKit

@IBDesignable
class ProfilePictureImageView : UIImageView {
    public var initials: String? {
        didSet {
            initialsLabel.isHidden = initials == nil
            initialsLabel.text = initials
            setNeedsLayout()
        }
    }
    
    public let initialsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        initialsLabel.frame = bounds
    }
}

extension ProfilePictureImageView {
    private func configure() {
        backgroundColor = #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        initialsLabel.textAlignment = .center
        initialsLabel.font = .systemFont(ofSize: 32)
        initialsLabel.textColor = .white
        addSubview(initialsLabel)
    }
}
