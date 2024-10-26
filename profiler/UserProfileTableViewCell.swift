import UIKit

class UserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var usernameLable: UILabel!
    @IBOutlet var userEmailLable: UILabel!
    @IBOutlet var userLocationLable: UILabel!
    @IBOutlet var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else { return }
        
        // Show a placeholder image while loading
        userImageView.image = nil // Optionally set a placeholder image here
        
        // Create a data task to fetch the image
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            // Check for errors and valid data
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            // Update the image view on the main thread
            DispatchQueue.main.async {
                self.userImageView.image = image
            }
        }.resume()
    }
    
}
