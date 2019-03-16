import Foundation

extension Academic {
    init(object: AcademicObject) {
        self.id = object.id
        self.fullName = "\(object.firstName) \(object.lastName)"
        self.profilePicture = object.profilePicture.flatMap({ URL(string: $0) })
        self.email = object.email
        self.phoneNumbers = Array(object.phoneNumbers)
        self.website = object.website
        self.title = object.title
        self.homePrograms = Array(object.homePrograms)
        self.researchDescription = object.researchDescription
        self.researchSummary = object.researchSummary
        self.publications = []
        self.similarAcademics = Array(object.similarAcademics)
    }
    
    var object: AcademicObject {
        return AcademicObject(academic: self)
    }
}
