import UIKit
import RealmSwift

class FacultyViewController : UIViewController {
    private let searchResultsController = SearchResultsViewController()
    private lazy var searchController = UISearchController(searchResultsController: self.searchResultsController)
    
    private var academics: [Academic] = []
    
    @IBOutlet var headerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    let realm = try! Realm()

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
        tableView.refreshControl = refreshControl
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        academics = realm.objects(AcademicObject.self).map({ Academic(object: $0 ) })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reload()
    }
}

extension FacultyViewController {
    private func reload() {
        academics = realm.objects(AcademicObject.self).map({ Academic(object: $0 ) })
        tableView.reloadData()
    }
}

extension FacultyViewController {
    @objc private func refresh() {
        reload()
        refreshControl.endRefreshing()
    }
}

extension FacultyViewController : SearchResultsViewControllerDelegate {
    func didSelectSearchResult(searchResult: Academic) {
        let searchResultViewController = AcademicViewController(academic: searchResult)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}

extension FacultyViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setBackgroundMessage(academics.isEmpty ? "No Faculty" : nil)
        navigationItem.largeTitleDisplayMode = academics.isEmpty ? .never : .always
        return academics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let academic = academics[indexPath.row]
        cell.textLabel?.attributedText = academic.attributedFullName(fontSize: 17)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension FacultyViewController : UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewBottomConstraint.constant = min(0, scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let academic = academics[indexPath.row]
        let academicViewController = AcademicViewController(academic: academic)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Faculty", style: .plain, target: nil, action: nil)
        navigationController?.pushViewController(academicViewController, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        guard editingStyle == .delete else {
            return
        }
        
        let academic = academics.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        guard let object = realm.object(ofType: AcademicObject.self, forPrimaryKey: academic.id) else {
            return
        }
        
        try! realm.write {
            realm.delete(object)
        }
    }
}
