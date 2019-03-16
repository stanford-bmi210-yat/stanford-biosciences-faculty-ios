import Realm
import RealmSwift
import Foundation

class AuthorObject : Object {
    @objc public dynamic var name: NameObject?
    
    init(author: Author) {
        self.name = NameObject(name: author.name)
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

extension Author {
    init(object: AuthorObject) {
        self.name = Name(object: object.name ?? NameObject())
    }
    
    var object: AuthorObject {
        return AuthorObject(author: self)
    }
}
