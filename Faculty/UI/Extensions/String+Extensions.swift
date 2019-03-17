import Foundation

extension String {
    func filterNonDecimalDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter({ CharacterSet.decimalDigits.contains($0) })
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
}
