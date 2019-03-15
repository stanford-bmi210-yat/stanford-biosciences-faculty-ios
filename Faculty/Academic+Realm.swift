import Realm
import RealmSwift
import Foundation

class AcademicObject : Object {
    @objc public dynamic var id: String = ""
    @objc public dynamic var firstName: String = ""
    @objc public dynamic var lastName: String = ""
    @objc public dynamic var profilePicture: String?
    @objc public dynamic var email: String = ""
    public let phoneNumbers = List<String>()
    @objc public dynamic var website: String = ""
    @objc public dynamic var title: String = ""
    public let homePrograms = List<String>()
    @objc public dynamic var currentResearch: String = ""
    public let recentPublications = List<String>()
    
    init(academic: Academic) {
        self.id = academic.id
        self.firstName = academic.firstName
        self.lastName = academic.lastName
        self.profilePicture = academic.profilePicture?.absoluteString
        self.email = academic.email
        self.phoneNumbers.append(objectsIn: academic.phoneNumbers)
        self.website = academic.website
        self.title = academic.title
        self.homePrograms.append(objectsIn: academic.homePrograms)
        self.currentResearch = academic.currentResearch
        self.recentPublications.append(objectsIn: academic.recentPublications)
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
        return "id"
    }
}
