import Foundation

public class Interactor {
    private let api: API
    private let database: Database
    
    public init() throws {
        self.api = API()
        self.database = try Database()
    }
    
    public var academicsCount: Int {
        return database.academicsCount
    }
    
    public func add(academic: Academic) throws {
        return try database.add(academic: academic)
    }
    
    public func add(academics: [Academic]) throws {
        return try database.add(academics: academics)
    }
    
    public func getAllAcademics() -> [Academic] {
        return database.getAllAcademics()
    }
    
    public func getAcademics(name: String) -> [Academic] {
        return database.getAcademics(name: name)
    }
    
    public func getAcademics(keyword: String) -> [Academic] {
        return database.getAcademics(keyword: keyword)
    }
    
    public func getAcademic(id: Int) -> Academic? {
        return database.getAcademic(id: id)
    }
    
    public func academicIsFavorite(id: Int) -> Bool {
        return database.academicIsFavorite(id: id)
    }
    
    public func deleteAcademic(id: Int) throws {
        return try database.deleteAcademic(id: id)
    }
    
    public func favoriteAcademic(id: Int) {
        return database.favoriteAcademic(id: id)
    }
    
    public func unfavoriteAcademic(id: Int) {
        return database.unfavoriteAcademic(id: id)
    }
    
    public func getFavoriteAcademics() -> [Academic] {
        return database.getFavoriteAcademics()
    }
    
    public func fetchAllAcademics(
        progress: @escaping (Float) -> Void,
        result: @escaping ([Academic]?, Error?) -> Void
    ) {
        return api.fetchAllAcademics(progress: progress, result: result)
    }
    
    public func fetchAcademic(id: Int, result: @escaping (Academic?, Error?) -> Void) {
        return api.fetchAcademic(id: id, result: result)
    }
    
    public func fetchAcademicIds(keyword: String, result: @escaping ([String]?, Error?) -> Void) {
        return api.fetchAcademicIds(keyword: keyword, result: result)
    }
}
