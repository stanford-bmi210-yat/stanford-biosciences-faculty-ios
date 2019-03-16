import Realm
import RealmSwift
import Foundation

class AcademicObject : Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var firstName: String = ""
    @objc public dynamic var lastName: String = ""
    @objc public dynamic var profilePicture: String?
    @objc public dynamic var email: String? = ""
    public let phoneNumbers = List<String>()
    @objc public dynamic var website: String = ""
    @objc public dynamic var title: String = ""
    public let homePrograms = List<String>()
    @objc public dynamic var researchDescription: String = ""
    @objc public dynamic var researchSummary: String = ""
    public let publications = List<String>()
    public let similarAcademics = List<Int>()
    
    init(academic: Academic) {
        self.id = academic.id
        self.firstName = academic.firstName
        self.lastName = academic.lastName
        self.profilePicture = academic.profilePicture?.absoluteString
        self.email = academic.email
        
        if let phoneNumbers = academic.phoneNumbers {
            self.phoneNumbers.append(objectsIn: phoneNumbers)
        }
        
        self.website = academic.website
        self.title = academic.title
        self.homePrograms.append(objectsIn: academic.homePrograms)
        self.researchDescription = academic.researchDescription
        self.researchSummary = academic.researchSummary
//        self.publications.append(objectsIn: academic.publications)
        self.similarAcademics.append(objectsIn: academic.similarAcademics)
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
