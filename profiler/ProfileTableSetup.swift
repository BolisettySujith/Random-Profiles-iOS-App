import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell", for: indexPath) as! UserProfileTableViewCell
        
        if !filteredUsersDataItems.isEmpty {
            let userProfile = filteredUsersDataItems[indexPath.row].userProfile
            cell.userEmailLable?.text = userProfile.email
            cell.usernameLable?.text = userProfile.username
            cell.userLocationLable?.text = userProfile.location
            cell.loadImage(from: userProfile.imageUrl)
        } else {
            let userProfile = usersDataItems[indexPath.row].userProfile
            cell.userEmailLable?.text = userProfile.email
            cell.usernameLable?.text = userProfile.username
            cell.userLocationLable?.text = userProfile.location
            cell.loadImage(from: userProfile.imageUrl)
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredUsersDataItems.isEmpty {
            return filteredUsersDataItems.count
        }
        
        return filtered ? 0 : usersDataItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = usersDataItems[indexPath.row]
        performSegue(withIdentifier: "ShowUserProfile", sender: selectedUser)
    }
    
    // Prepare for segue to UserProfileViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserProfile" {
            if let userProfileVC = segue.destination as? UserProfileViewController,
               let selectedUser = sender as? User {
                userProfileVC.user = selectedUser
            }
        }
    }
}
