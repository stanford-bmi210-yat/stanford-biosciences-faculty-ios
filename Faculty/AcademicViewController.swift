import UIKit
import Kingfisher
import RealmSwift

class AcademicViewController : UIViewController {
    let academic: Academic
    
    @IBOutlet private var profilePicture: ProfilePictureImageView!
    @IBOutlet private var fullNameLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var topViewHeightConstraint: NSLayoutConstraint!
    
    private let topViewMinHeight: CGFloat = 260
    private let topViewMaxHeight: CGFloat = 300
    
    var content: [(String, [String])]
    
    let realm = try! Realm()
    
    var academicIsNotStored: Bool {
        return realm.object(ofType: AcademicObject.self, forPrimaryKey: academic.id) == nil
    }
    
    init(academic: Academic) {
        self.academic = academic
        
        var content: [(String, [String])] = []
        
        if !academic.title.isEmpty {
            content.append(("Title", [academic.title]))
        }
        
        if !academic.homePrograms.isEmpty {
            content.append(("Home Programs", academic.homePrograms))
        }
        
        if !academic.currentResearch.isEmpty {
            content.append(("Current Research", [academic.currentResearch]))
        }
        
        if !academic.email.isEmpty {
            content.append(("Email", [academic.email]))
        }
        
        if !academic.phoneNumbers.isEmpty {
            content.append(("Phone Numbers", academic.phoneNumbers))
        }
        
        if !academic.website.isEmpty {
            content.append(("Website", [academic.website]))
        }
        
        if !academic.recentPublications.isEmpty {
            content.append(("Recent Publications", academic.recentPublications))
        }
        
        self.content = content
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        fullNameLabel.attributedText = academic.attributedFullName(fontSize: 17)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceHorizontal = true
        let nib = UINib(nibName: "RelatedAcademicCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: topViewHeightConstraint.constant, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        
        view.backgroundColor = .groupTableViewBackground
        
        profilePicture.kf.setImage(
            with: academic.profilePicture,
            placeholder: #imageLiteral(resourceName: "male-plaecholder.jpg")
        )
        
        updateActionButton()
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

extension AcademicViewController {
    @objc private func action() {
        defer {
            updateActionButton()
        }
        
        guard academicIsNotStored else {
            return deleteAcademic()
        }
        
        addAcademic()
    }
}

extension AcademicViewController {
    private func updateActionButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: academicIsNotStored ? .add : .trash,
            target: self,
            action: #selector(action)
        )
    }
    
    private func addAcademic() {
        try! realm.write {
            realm.add(academic.object)
        }
    }
    
    private func deleteAcademic() {
        guard let object = realm.object(ofType: AcademicObject.self, forPrimaryKey: academic.id) else {
            return
        }
        
        try! realm.write {
            return realm.delete(object)
        }
    }
}

extension AcademicViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return academic.relatedAcademics.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RelatedAcademicCollectionViewCell
        
        let relatedAcademic = academic.relatedAcademics[indexPath.item]
        
        cell.imageView.kf.setImage(
            with: relatedAcademic.profilePicture,
            placeholder: #imageLiteral(resourceName: "male-plaecholder.jpg")
        )
        
        cell.textLabel.text = relatedAcademic.lastName        
        return cell
    }
}

extension AcademicViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let relatedAcademic = academic.relatedAcademics[indexPath.item]
        
        guard let academic = Academic.all.first(where: { $0.id == relatedAcademic.id }) else {
            return
        }
        
        let academicViewController = AcademicViewController(academic: academic)
        navigationController?.pushViewController(academicViewController, animated: true)
    }
}

extension AcademicViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content[section].1.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.content[section].0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let view = view as? UITableViewHeaderFooterView else {
            return
        }
        
        view.textLabel?.textColor = #colorLiteral(red: 0.3019607843, green: 0.3098039216, blue: 0.3254901961, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let content = self.content[indexPath.section].1[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = content
        cell.textLabel?.font = .systemFont(ofSize: 13)
        
        return cell
    }
}
