import Realm
import RealmSwift
import Foundation

class NameObject : Object {
    @objc public dynamic var firstNameInitial: String?
    @objc public dynamic var lastName: String = ""
    
    init(name: Name) {
        self.firstNameInitial = name.firstNameInitial
        self.lastName = name.lastName
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
}

extension Name {
    init(object: NameObject) {
        self.firstNameInitial = object.firstNameInitial
        self.lastName = object.lastName
    }
    
    var object: NameObject {
        return NameObject(name: self)
    }
}
