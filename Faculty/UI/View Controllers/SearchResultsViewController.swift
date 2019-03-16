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
    
    private let nameSearchResults: [Academic] = [
        .mark,
        .sanjiv,
        .andrew,
        .jonathan,
        .christina,
        .catherine,
        .hunter,
    ]
    
    private let keywordSearchResults: [Academic] = [
        .catherine,
        .hunter,
        .mark,
        .sanjiv,
    ]
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        tableView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9647058824, blue: 0.937254902, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SearchResultsViewController {
    private func updateResults(scope: SearchScope) {
        if scope == .name {
            searchResults = nameSearchResults
        } else {
            searchResults = keywordSearchResults
        }
        
        tableView.reloadData()
    }
}

extension SearchResultsViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let scope = SearchScope(rawValue: selectedScope) else {
            return
        }
        
        updateResults(scope: scope)
    }
}

extension SearchResultsViewController : UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let scope = SearchScope(rawValue: searchController.searchBar.selectedScopeButtonIndex) else {
            return
        }
        
        updateResults(scope: scope)
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
