import Foundation

extension CharacterSet {
    public var members: [String] {
        let characterSet = self as NSCharacterSet
        let unichars = Array(unichar(0)..<unichar(128)).filter(characterSet.characterIsMember)
        return unichars.map({ String(UnicodeScalar($0)!) })
    }
}
