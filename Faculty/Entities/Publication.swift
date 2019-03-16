import Foundation

public struct Publication : Decodable {
    public let uuid: String
    public let title: String
    public let authors: [Author]?
    public let year: Int?
    public let url: URL
    public let journal: String?
    public let fullCitation: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case title = "title"
        case authors = "authors"
        case year = "year"
        case url = "linkAddress"
        case journal = "journal"
        case fullCitation = "fullCitation"
    }
    
    public init(title: String) {
        self.uuid = UUID().uuidString
        self.title = title
        self.authors = []
        self.year = 2019
        self.url = URL(string: "https://apple.com")!
        self.journal = nil
        self.fullCitation = ""
    }
}
