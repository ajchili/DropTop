import UIKit
import FirebaseAuth

class AccountSettingsViewController: UIViewController, UITextFieldDelegate {
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Display Name"
        return label
    }()
    
    let displayName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Display Name"
        tf.font = UIFont.systemFont(ofSize: 26)
        return tf
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "All settings save when you leave this screen"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account Settings"
        view.backgroundColor = .white

        setupView()
        loadUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName.text!
        changeRequest?.commitChanges { (error) in
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    fileprivate func setupView() {
        view.addSubview(displayNameLabel)
        displayNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(displayName)
        displayName.anchor(top: displayNameLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        displayName.delegate = self
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
    }
    
    fileprivate func loadUser() {
        let user = Auth.auth().currentUser
        
        displayName.text = user?.displayName!
    }
}
