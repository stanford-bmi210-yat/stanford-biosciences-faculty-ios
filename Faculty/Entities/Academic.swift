import UIKit

public struct Academic : Decodable {
    public let id: Int
    public let fullName: String
    public let profilePicture: URL?
    public let email: String?
    public let phoneNumbers: [String]?
    public let website: URL
    public let title: String
    public let homePrograms: [String]
    public let researchDescription: String
    public let researchSummary: String
    public let publications: [Publication]?
    public let similarAcademics: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case fullName = "name"
        case profilePicture = "imageAddress"
        case email = "emailAddress"
        case phoneNumbers = "phoneNumbers"
        case website = "websiteAddress"
        case title = "jobTitle"
        case homePrograms = "homePrograms"
        case researchSummary = "researchSummary"
        case researchDescription = "researchDescription"
        case publications = "publications"
        case similarAcademics = "similarProfessors"
    }
    
    public var firstName: String {
        var names = fullName.components(separatedBy: " ")
        return names.removeFirst()
    }
    
    public var lastName: String {
        var names = fullName.components(separatedBy: " ")
        names.removeFirst()
        return names.joined(separator: " ")
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
