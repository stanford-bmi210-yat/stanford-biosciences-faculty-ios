import RealmSwift

public enum DatabaseError : Error {
    case academicNotFound(id: Int)
}

public class Database {
    private let realm: Realm
    
    public init() throws {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 10,
            migrationBlock: { migration, oldSchemaVersion in
                
                
            },
            deleteRealmIfMigrationNeeded: true
        )
        
        self.realm = try Realm()
    }
    
    public var academicsCount: Int {
        return realm.objects(AcademicObject.self).count
    }
    
    public func add(academic: Academic) throws {
        try realm.write {
            realm.add(academic.object)
        }
    }
    
    public func add(academics: [Academic]) throws {
        try realm.write {
            realm.add(academics.map({ $0.object }))
        }
    }
    
    public func getAllAcademics() -> [Academic] {
        return realm.objects(AcademicObject.self)
            .sorted(byKeyPath: "lastName")
            .map({ Academic(object: $0 ) })
    }
    
    public func academicIsStored(id: Int) -> Bool {
        return realm.object(ofType: AcademicObject.self, forPrimaryKey: id) != nil
    }
    
    public func getAcademic(id: Int) -> Academic? {
        return realm.object(ofType: AcademicObject.self, forPrimaryKey: id).map({ Academic(object: $0 ) })
    }
    
    public func deleteAcademic(id: Int) throws {
        guard let object = realm.object(ofType: AcademicObject.self, forPrimaryKey: id) else {
            throw DatabaseError.academicNotFound(id: id)
        }
        
        try realm.write {
            realm.delete(object)
        }
    }
}
