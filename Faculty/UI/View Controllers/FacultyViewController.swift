import UIKit

class FacultyViewController : UIViewController {
    private let interactor: Interactor
    
    private lazy var searchResultsController = SearchResultsViewController(interactor: interactor)
    private lazy var searchController = UISearchController(searchResultsController: searchResultsController)
    
    private var data: [(initial: String, academics: [Academic])] = []
    
    @IBOutlet var headerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Faculty"
        definesPresentationContext = true
        searchResultsController.delegate = self
        
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchBar.delegate = searchResultsController
        searchController.searchBar.tintColor = #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        searchController.searchBar.scopeButtonTitles = ["Name", "Keyword"]
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)]
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        data = interactor.getAllAcademics()
            .reduce(into: [:] as [String: [Academic]]) { result, academic in
                let initial = String(academic.lastName.prefix(1)).uppercased()
                result[initial] = (result[initial] ?? []) + [academic]
            }.reduce(into: [] as [(String, [Academic])]) { result, element in
                let (initial, academics) = element
                
                let sortedAcademics = academics.sorted {
                    guard $0.lastName != $1.lastName else {
                        return $0.firstName < $1.firstName
                    }
                    
                    return $0.lastName < $1.lastName
                }
                
                result.append((initial, sortedAcademics))
            }.sorted { lhs, rhs in
                lhs.initial.uppercased() < rhs.initial.uppercased()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.view.backgroundColor = .clear
    }
}

extension FacultyViewController : SearchResultsViewControllerDelegate {
    func didSelectSearchResult(searchResult: Academic) {
        let searchResultViewController = AcademicViewController(interactor: interactor, academic: searchResult)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}

extension FacultyViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].academics.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].initial
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return data.map({ $0.initial })
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return data.firstIndex(where: { $0.initial == title }) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let academic = data[indexPath.section].academics[indexPath.row]
        cell.textLabel?.attributedText = academic.attributedFullName(fontSize: 17)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension FacultyViewController : UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewBottomConstraint.constant = min(0, scrollView.contentOffset.y)
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplayHeaderView view: UIView,
        forSection section: Int
    ) {
        view.tintColor = #colorLiteral(red: 0.9764705882, green: 0.9647058824, blue: 0.937254902, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let academic = data[indexPath.section].academics[indexPath.row]
        let academicViewController = AcademicViewController(interactor: interactor, academic: academic)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Faculty", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(academicViewController, animated: true)
    }
}
