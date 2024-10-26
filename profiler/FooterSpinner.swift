import UIKit

extension UIViewController {
    func createFooterSpinner() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footer.center
        
        footer.addSubview(spinner)
        spinner.startAnimating()
        
        return footer
    }
}
