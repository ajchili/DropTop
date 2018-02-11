import UIKit

class DropViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Drops"
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = title
        navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func setupView() {
        
    }
}
