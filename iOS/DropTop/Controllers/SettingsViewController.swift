import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    let accountSettings: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Account Settings", for: .normal)
        button.addTarget(self, action: #selector(handleViewAccount), for: .touchUpInside)
        return button
    }()
    
    let feedback: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Feedback", for: .normal)
        button.addTarget(self, action: #selector(handleFeedback), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = title
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = logout
        navigationController?.navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @objc func handleViewAccount() {
        navigationController?.pushViewController(AccountSettingsViewController(), animated: true)
    }
    
    @objc func handleFeedback() {
        navigationController?.pushViewController(FeedbackViewController(), animated: true)
    }
    
    fileprivate func setupView() {
        view.addSubview(accountSettings)
        accountSettings.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(feedback)
        feedback.anchor(top: accountSettings.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
