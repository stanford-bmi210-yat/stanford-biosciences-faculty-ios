import Realm
import RealmSwift
import Foundation

class PublicationObject : Object {
    @objc public dynamic var uuid: String = ""
    @objc public dynamic var title: String = ""
    public let authors = List<AuthorObject>()
    public let year = RealmOptional<Int>()
    @objc public dynamic var url: String = ""
    @objc public dynamic var journal: String?
    @objc public dynamic var fullCitation: String = ""
    
    init(publication: Publication) {
        self.uuid = publication.uuid
        self.title = publication.title
        
        if let authors = publication.authors {
            self.authors.append(objectsIn: authors.map({ $0.object }))
        }
        
        self.year.value = publication.year
        self.url = publication.url.absoluteString
        self.journal = publication.journal
        self.fullCitation = publication.fullCitation
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

extension Publication {
    init(object: PublicationObject) {
        self.uuid = object.uuid
        self.title = object.title
        self.authors = object.authors.map({ Author(object: $0) })
        self.year = object.year.value
        self.url = URL(string: object.url)!
        self.journal = object.journal
        self.fullCitation = object.fullCitation
    }
    
    var object: PublicationObject {
        return PublicationObject(publication: self)
    }
}
