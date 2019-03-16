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
    
    public func getAcademic(id: Int) -> Academic? {
        return database.getAcademic(id: id)
    }
    
    public func academicIsStored(id: Int) -> Bool {
        return database.academicIsStored(id: id)
    }
    
    public func deleteAcademic(id: Int) throws {
        return try database.deleteAcademic(id: id)
    }
    
    public func queryAllAcademics(
        progress: @escaping (Float) -> Void,
        result: @escaping ([Academic]?, Error?) -> Void
    ) {
        return api.queryAllAcademics(progress: progress, result: result)
    }
    
    public func queryAcademic(id: Int, result: @escaping (Academic?, Error?) -> Void) {
        return api.queryAcademic(id: id, result: result)
    }
}
