import RealmSwift
import Foundation

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
    
    public func getAllAcademicSummaries() -> [AcademicSummary] {
        return realm.objects(AcademicObject.self)
            .sorted(byKeyPath: "lastName")
            .map({ AcademicSummary(object: $0 ) })
    }
    
    public func getAcademics(name: String) -> [AcademicSummary] {
        return realm.objects(AcademicObject.self)
            .filter("fullName CONTAINS[cd] '\(name)'")
            .sorted(byKeyPath: "lastName")
            .map({ AcademicSummary(object: $0 ) })
    }
    
    public func getAcademics(keyword: String) -> [AcademicSummary] {
        return realm.objects(AcademicObject.self)
            .filter("researchSummary CONTAINS[cd] '\(keyword)'")
            .sorted(byKeyPath: "lastName")
            .map({ AcademicSummary(object: $0 ) })
    }
    
    public func getAcademic(id: Int) -> Academic? {
        return realm.object(ofType: AcademicObject.self, forPrimaryKey: id).map({ Academic(object: $0 ) })
    }
    
    public func getAcademics(ids: [Int]) -> [Academic] {
        let predicate = NSPredicate(format: "id IN %@", ids)
        
        return realm.objects(AcademicObject.self)
            .filter(predicate)
            .sorted(byKeyPath: "lastName")
            .map({ Academic(object: $0 ) })
    }
    
    public func deleteAcademic(id: Int) throws {
        guard let object = realm.object(ofType: AcademicObject.self, forPrimaryKey: id) else {
            throw DatabaseError.academicNotFound(id: id)
        }
        
        try realm.write {
            realm.delete(object)
        }
    }
    
    public func favoriteAcademic(id: Int) {
        guard let favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] else {
            return UserDefaults.standard.set([id], forKey: "favorites")
        }
        
        UserDefaults.standard.set(favorites + [id], forKey: "favorites")
    }
    
    public func unfavoriteAcademic(id: Int) {
        guard let favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] else {
            return
        }
        
        UserDefaults.standard.set(favorites.filter({ $0 != id }), forKey: "favorites")
    }
    
    public func academicIsFavorite(id: Int) -> Bool {
        guard let favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] else {
            return false
        }
        
        return favorites.contains(id)
    }
    
    public func getFavoriteAcademics() -> [Academic] {
        guard let favorites = UserDefaults.standard.object(forKey: "favorites") as? [Int] else {
            return []
        }
        
        return getAcademics(ids: favorites)
    }
}
