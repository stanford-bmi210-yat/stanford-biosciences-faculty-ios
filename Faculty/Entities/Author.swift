import Foundation

public struct Author : Decodable {
    public let name: Name
    
    enum CodingKeys: String, CodingKey {
        case name = "initialLast"
    }
}
