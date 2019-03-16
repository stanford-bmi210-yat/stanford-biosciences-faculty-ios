import UIKit

class FavoritesViewController : UIViewController {
    private let interactor: Interactor
    private var favoriteAcademics: [Academic] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerViewBottomConstraint: NSLayoutConstraint!
    
    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        title = "Favorites"
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9764705882, green: 0.9647058824, blue: 0.937254902, alpha: 1)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.5490196078, green: 0.08235294118, blue: 0.08235294118, alpha: 1)]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.view.backgroundColor = .clear
        reload()
    }
}

extension FavoritesViewController {
    private func reload() {
        favoriteAcademics = interactor.getFavoriteAcademics()
        tableView.reloadData()
    }
}

extension FavoritesViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteAcademics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let academic = favoriteAcademics[indexPath.row]
        cell.textLabel?.attributedText = academic.attributedFullName(fontSize: 17)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension FavoritesViewController : UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewBottomConstraint.constant = min(0, scrollView.contentOffset.y)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let academic = favoriteAcademics[indexPath.row]
        let academicViewController = AcademicViewController(interactor: interactor, academic: academic)
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
        
        let academic = favoriteAcademics.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        interactor.unfavoriteAcademic(id: academic.id)
    }
}
