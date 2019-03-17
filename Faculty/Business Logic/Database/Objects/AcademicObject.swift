import Realm
import RealmSwift
import Foundation

class AcademicObject : Object {
    @objc public dynamic var id: Int = 0
    @objc public dynamic var fullName: String = ""
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
    public let publications = List<PublicationObject>()
    public let similarAcademics = List<Int>()
    
    init(academic: Academic) {
        self.id = academic.id
        self.fullName = academic.fullName
        self.firstName = academic.firstName
        self.lastName = academic.lastName
        self.profilePicture = academic.profilePicture?.absoluteString
        self.email = academic.email
        
        if let phoneNumbers = academic.phoneNumbers {
            self.phoneNumbers.append(objectsIn: phoneNumbers)
        }
        
        self.website = academic.website.absoluteString
        self.title = academic.title
        self.homePrograms.append(objectsIn: academic.homePrograms)
        self.researchDescription = academic.researchDescription
        self.researchSummary = academic.researchSummary
        
        if let publications = academic.publications {
            self.publications.append(objectsIn: publications.map({ $0.object }))
        }
        
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

extension Academic {
    init(object: AcademicObject) {
        self.id = object.id
        self.fullName = object.fullName
        self.profilePicture = object.profilePicture.flatMap({ URL(string: $0) })
        self.email = object.email
        self.phoneNumbers = Array(object.phoneNumbers)
        self.website = URL(string: object.website)!
        self.title = object.title
        self.homePrograms = Array(object.homePrograms)
        self.researchDescription = object.researchDescription
        self.researchSummary = object.researchSummary
        self.publications = object.publications.map({ Publication(object: $0) })
        self.similarAcademics = Array(object.similarAcademics)
    }
    
    var object: AcademicObject {
        return AcademicObject(academic: self)
    }
}

extension AcademicSummary {
    init(object: AcademicObject) {
        self.id = object.id
        self.fullName = object.fullName
    }
}
