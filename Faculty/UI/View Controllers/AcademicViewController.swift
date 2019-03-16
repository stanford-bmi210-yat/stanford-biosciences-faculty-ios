import UIKit
import Kingfisher
import RealmSwift

class AcademicViewController : UIViewController {
    private let interactor: Interactor
    private let academic: Academic
    
    @IBOutlet private var profilePicture: ProfilePictureImageView!
    @IBOutlet private var fullNameLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var topViewHeightConstraint: NSLayoutConstraint!
    
    private let topViewMinHeight: CGFloat = 260
    private let topViewMaxHeight: CGFloat = 300
    
    var content: [(String, [String])]
    
    var academicIsStored: Bool {
        return interactor.academicIsStored(id: academic.id)
    }
    
    init(interactor: Interactor, academic: Academic) {
        self.interactor = interactor
        self.academic = academic
        
        var content: [(String, [String])] = []
        
        if !academic.title.isEmpty {
            content.append(("Title", [academic.title]))
        }
        
        if !academic.homePrograms.isEmpty {
            content.append(("Home Programs", academic.homePrograms))
        }
        
        if !academic.researchDescription.isEmpty {
            content.append(("Current Research", [academic.researchDescription]))
        }
        
        if let email = academic.email, !email.isEmpty {
            content.append(("Email", [email]))
        }
        
        if let phoneNumbers = academic.phoneNumbers, !phoneNumbers.isEmpty {
            content.append(("Phone Numbers", phoneNumbers))
        }
        
        if !academic.website.isEmpty {
            content.append(("Website", [academic.website]))
        }
        
        if let publications = academic.publications, !publications.isEmpty {
            content.append(("Recent Publications", publications.map({ $0.title })))
        }
        
        self.content = content
        
        super.init(nibName: nil, bundle: nil)
        
        hidesBottomBarWhenPushed = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
        
        if let url = academic.profilePicture {
            profilePicture.kf.setImage(
                with: url,
                placeholder: #imageLiteral(resourceName: "male-plaecholder.jpg")
            ) { result in
                guard result.value?.image.size == CGSize(width: 1, height: 1) else {
                    return
                }
                
                self.profilePicture.image = #imageLiteral(resourceName: "male-plaecholder.jpg")
            }
        } else {
            profilePicture.image = #imageLiteral(resourceName: "male-plaecholder.jpg")
        }
        
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
        
        alertErrorOnFailure {
            // favorite
        }
    }
}

extension AcademicViewController {
    private func updateActionButton() {
//        navigationItem.rightBarButtonItem = academicIsStored ? nil : UIBarButtonItem(
//            barButtonSystemItem: .add,
//            target: self,
//            action: #selector(action)
//        )
    }
}

extension AcademicViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return academic.similarAcademics.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RelatedAcademicCollectionViewCell
        
        let id = academic.similarAcademics[indexPath.item]
        
        guard let academic = interactor.getAcademic(id: id) else {
            return cell
        }
        
        if let url = academic.profilePicture {
            cell.imageView.kf.setImage(
                with: url,
                placeholder: #imageLiteral(resourceName: "male-plaecholder.jpg")
            ) { result in
                guard result.value?.image.size == CGSize(width: 1, height: 1) else {
                    return
                }
                
                cell.imageView.image = #imageLiteral(resourceName: "male-plaecholder.jpg")
            }
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "male-plaecholder.jpg")
        }
        
        cell.textLabel.text = academic.lastName
        return cell
    }
}

extension AcademicViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = academic.similarAcademics[indexPath.item]
        
        guard let academic = interactor.getAcademic(id: id) else {
            return
        }
        
        let academicViewController = AcademicViewController(interactor: interactor, academic: academic)
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
