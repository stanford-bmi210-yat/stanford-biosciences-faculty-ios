import UIKit

extension UITableView {
    func setBackgroundMessage(_ message: String?) {
        guard let message = message else {
            backgroundView = nil
            return separatorStyle = .singleLine
        }
        
        let frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        let label = UILabel(frame: frame)
        label.text = message
        label.numberOfLines = 0
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17)
        label.sizeToFit()
        
        backgroundView = label
        separatorStyle = .none
    }
}
