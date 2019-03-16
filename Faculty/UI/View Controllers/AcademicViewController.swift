import UIKit
import Kingfisher
import RealmSwift

enum Row {
    case similarFaculty
    case text(String)
    case publication(Publication)
}

class AcademicViewController : UIViewController {
    private let interactor: Interactor
    private let academic: Academic
    
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var profilePicture: ProfilePictureImageView!
    @IBOutlet private var fullNameLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    
    private let topViewMinHeight: CGFloat = 260
    private let topViewMaxHeight: CGFloat = 300
    
    var content: [(String, [Row])]
    
    var academicIsFavorite: Bool {
        return interactor.academicIsFavorite(id: academic.id)
    }
    
    init(interactor: Interactor, academic: Academic) {
        self.interactor = interactor
        self.academic = academic
        
        var content: [(String, [Row])] = []
        
        if !academic.title.isEmpty {
            content.append(("Title", [.text(academic.title)]))
        }
        
        if !academic.homePrograms.isEmpty {
            content.append(("Home Programs", academic.homePrograms.map({ .text($0) })))
        }
        
        if !academic.researchSummary.isEmpty {
            content.append(("Research Summary", [.text(academic.researchSummary)]))
        }
        
        if !academic.researchDescription.isEmpty {
            content.append(("Current Research", [.text(academic.researchDescription)]))
        }
        
//        if let email = academic.email, !email.isEmpty {
//            content.append(("Email", [.text(email)]))
//        }
//
//        if let phoneNumbers = academic.phoneNumbers, !phoneNumbers.isEmpty {
//            content.append(("Phone Numbers", phoneNumbers.map({ .text($0) })))
//        }
//
//        if !academic.website.isEmpty {
//            content.append(("Website", [.text(academic.website)]))
//        }
        
        content.append(("Similar Faculty", [.similarFaculty]))
        
        if let publications = academic.publications, !publications.isEmpty {
            content.append(("Publications", publications.map({ .publication($0) })))
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
        view.backgroundColor = .groupTableViewBackground
        navigationItem.largeTitleDisplayMode = .never
        
        if let url = academic.profilePicture {
            profilePicture.kf.setImage(
                with: url,
                placeholder: #imageLiteral(resourceName: "PersonPlaceholder.png")
            ) { result in
                guard result.value?.image.size == CGSize(width: 1, height: 1) else {
                    return
                }
                
                self.profilePicture.image = #imageLiteral(resourceName: "PersonPlaceholder.png")
            }
        } else {
            profilePicture.image = #imageLiteral(resourceName: "PersonPlaceholder.png")
        }
        
        fullNameLabel.attributedText = academic.attributedFullName(fontSize: 17)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.contentInset = UIEdgeInsets(
            top: headerView.bounds.height,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "text")
        let nib = UINib(nibName: "SimilarFacultyTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "similar-faculty")
        
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
        
        if academicIsFavorite {
            interactor.unfavoriteAcademic(id: academic.id)
        } else {
            interactor.favoriteAcademic(id: academic.id)
        }
    }
}

extension AcademicViewController {
    private func updateActionButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: academicIsFavorite ? #imageLiteral(resourceName: "HeartFilled.png") : #imageLiteral(resourceName: "HeartOutline.png"),
            style: .plain,
            target: self,
            action: #selector(action)
        )
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
                placeholder: #imageLiteral(resourceName: "PersonPlaceholder.png")
            ) { result in
                guard result.value?.image.size == CGSize(width: 1, height: 1) else {
                    return
                }
                
                cell.imageView.image = #imageLiteral(resourceName: "PersonPlaceholder.png")
            }
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "PersonPlaceholder.png")
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
        let row = self.content[indexPath.section].1[indexPath.row]
        
        switch row {
        case .similarFaculty:
            let cell = tableView.dequeueReusableCell(withIdentifier: "similar-faculty", for: indexPath) as! SimilarFacultyTableViewCell
            
            if cell.collectionView.dataSource !== self {
                cell.selectionStyle = .none
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
            }
            
            return cell
        case let .publication(publication):
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath)
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = publication.title
            cell.textLabel?.font = .systemFont(ofSize: 13)
            cell.selectionStyle = .none
            
            return cell
        case let .text(content):
            let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath)
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = content
            cell.textLabel?.font = .systemFont(ofSize: 13)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

extension AcademicViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.content[indexPath.section].1[indexPath.row]
        
        switch row {
        case let .publication(publication):
            UIApplication.shared.open(publication.url)
        default:
            return
        }
    }
}
