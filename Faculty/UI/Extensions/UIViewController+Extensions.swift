import UIKit

extension UIViewController {
    public func alertErrorOnFailure(action: () throws -> Void) {
        alertErrorOnFailure(action: action) as Void?
    }
    
    @discardableResult
    public func alertErrorOnFailure<T>(action: () throws -> T) -> T? {
        do {
            return try action()
        } catch {
            alert(error: error)
            return nil
        }
    }
    
    public func alert(error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}
