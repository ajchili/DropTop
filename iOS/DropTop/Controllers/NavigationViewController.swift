import UIKit
import FirebaseAuth

class NavigationViewController: UINavigationController {
    
    var handler: AuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        pushViewController(TabViewController(), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handler!)
    }
}
