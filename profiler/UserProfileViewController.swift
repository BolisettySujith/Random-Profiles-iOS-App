import UIKit
import Foundation

class UserProfileViewController: UIViewController {
    
    var user: User?

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userGenderAndAgeLabel: UILabel!
    @IBOutlet weak var userDOBLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userNumberLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.contentMode = .scaleAspectFill
        userProfileImage.clipsToBounds = true // Ensure any overflow is clipped
        // Set up the gradient
        addGradientLayer()
        updateUI()
    }
    
    private func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = userProfileImage.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor] // Black to transparent
        gradientLayer.locations = [0.0, 1.0] // Start and end points for the gradient

        // Ensure the gradient layer resizes with the image view
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0) // Start from bottom
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0) // End at top
        
        userProfileImage.layer.addSublayer(gradientLayer)
    }

    private func updateUI() {
        guard let user = user else { return }
        
        userNameLabel.text = user.userProfile.username
        userEmailLabel.text = user.email

        // Include all details in user location
        let street = "\(user.location.street.number) \(user.location.street.name)"
        let city = user.location.city
        let state = user.location.state
        let country = user.location.country
        let postcode = user.location.postcode
        
        userLocationLabel.text = "\(street), \(city), \(state), \(postcode), \(country)"

        userGenderAndAgeLabel.text = "\(user.gender.capitalized), \(user.dob.age)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjusted for your date format
        if let date = dateFormatter.date(from: user.dob.date) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy" // Set the desired output format
            userDOBLabel.text = formatter.string(from: date).replacing("-", with: "/", maxReplacements: 2)
        } else {
            userDOBLabel.text = user.dob.date // Fallback if formatting fails
        }
        userNumberLabel.text = "\(user.phone)"
        
        // Load image from URL
        if let url = URL(string: user.picture.large) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.userProfileImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }

}
