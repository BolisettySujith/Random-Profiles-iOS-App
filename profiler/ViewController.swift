import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private let apiCaller = UsersAPICaller()
    
    @IBOutlet var searchField : UITextField!
    @IBOutlet var tableView: UITableView!
    
    var usersDataItems = [User]()
    var filteredUsersDataItems = [User]()
    var filtered = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users Profiles"
        
        let nib = UINib(nibName: "UserProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "userProfileTableViewCell")

        tableView.dataSource = self
        tableView.delegate = self
        searchField.delegate = self

        // Set navigation bar appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor.systemYellow
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        // Set the status bar style
        // This will require setting the UIViewController's preferredStatusBarStyle
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
        self.tableView.tableFooterView = self.createFooterSpinner()
        fetchData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            filterText(updatedText)
        }
        return true
    }
    
    func filterText(_ query: String) {
        
        filteredUsersDataItems.removeAll()
        for user in usersDataItems {
            if user.userProfile.username.lowercased().starts(with: query.lowercased()) {
                filteredUsersDataItems.append(user)
            }
        }
        tableView.reloadData()
        filtered = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.height) {
             guard !apiCaller.isPaginating else {
                 return
             }
            
            self.tableView.tableFooterView = createFooterSpinner()
            fetchData(pagination: true)
        }
    }
    
    func fetchData(pagination: Bool = false) {
        apiCaller.fetchApiUserData(paginaiton: pagination, completion: {[weak self] result in
            DispatchQueue.main.async {
                self?.tableView.tableFooterView = nil
            }
            switch result {
                case .success(let moreUsersData):
                    self?.usersDataItems.append(contentsOf: moreUsersData)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                case .failure(_):
                    return
            }
            
        })
    }
}
