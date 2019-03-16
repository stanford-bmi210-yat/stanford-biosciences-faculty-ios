import Foundation

public struct Name : Decodable {
    public let firstNameInitial: String?
    public let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstNameInitial = "firstInitial"
        case lastName = "last"
    }
}
