import UIKit

protocol SearchResultsViewControllerDelegate : class {
    func didSelectSearchResult(searchResult: Academic)
}

enum SearchScope : Int {
    case name
    case keyword
}

class SearchResultsViewController : UIViewController {
    private let interactor: Interactor
    
    @IBOutlet var headerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    private var searchResults: [Academic] = []
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )

        tableView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9647058824, blue: 0.937254902, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SearchResultsViewController {
    @objc func keyboardWillChangeFrame(notification: Notification) {
        let userInfo = notification.userInfo!
        let window = view.window!
        let keyboardFrameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let tableViewWindowFrame = tableView.convert(tableView.bounds, to: window)
        let tableViewOffset = (window.bounds.height - tableViewWindowFrame.maxY)
        
        if keyboardFrameEnd.origin.y - window.bounds.height == 0 {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardFrameEnd.height - tableViewOffset,
                right: 0
            )
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

extension SearchResultsViewController {
    private func updateResults(scope: SearchScope, query: String) {
        defer {
            tableView.reloadData()
        }
        
        #warning("Instead of doing this, get only name and id for search results")
        guard query.count >= 3 else {
            return searchResults = []
        }
        
        if scope == .name {
            searchResults = interactor.getAcademics(name: query)
        } else {
            searchResults = interactor.getAcademics(keyword: query)
        }
    }
}

extension SearchResultsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scope = SearchScope(rawValue: selectedScope) else {
            return
        }
        
        updateResults(scope: scope, query: searchBar.text ?? "")
    }
}

extension SearchResultsViewController : UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let scope = SearchScope(rawValue: searchController.searchBar.selectedScopeButtonIndex) else {
            return
        }
        
        updateResults(scope: scope, query: searchController.searchBar.text ?? "")
    }
}

extension SearchResultsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Top Results"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let academic = searchResults[indexPath.row]
        cell.textLabel?.attributedText = academic.attributedFullName(fontSize: 17)
        
        return cell
    }
}

extension SearchResultsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults[indexPath.row]
        tableView.reloadData()
        delegate?.didSelectSearchResult(searchResult: searchResult)
    }
}
