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
}
