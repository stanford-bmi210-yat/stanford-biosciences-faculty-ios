import UIKit

protocol Named {
    var fullName: String { get }
}

extension Named {
    public var firstName: String {
        var names = fullName.components(separatedBy: " ")
        return names.removeFirst()
    }
    
    public var lastName: String {
        var names = fullName.components(separatedBy: " ")
        names.removeFirst()
        return names.joined(separator: " ")
    }
    
    public var firstNameInitial: String {
        return String(firstName.prefix(1)).uppercased()
    }
    
    public var lastNameInitial: String {
        return String(lastName.prefix(1)).uppercased()
    }
    
    public var initials: String {
        return lastNameInitial + firstNameInitial
    }
    
    public func attributedFullName(fontSize: CGFloat) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize)
        let boldFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        let fullName = NSMutableAttributedString(string: lastName, attributes: [.font: boldFont])
        fullName.append(NSAttributedString(string: ", ", attributes: [.font: font]))
        fullName.append(NSAttributedString(string: firstName, attributes: [.font: font]))
        return fullName
    }
}

extension Academic : Named {}
extension AcademicSummary : Named {}
