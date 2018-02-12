import UIKit
import FirebaseAuth
import FirebaseDatabase

class AccountSettingsViewController: UIViewController, UITextFieldDelegate {
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Display Name"
        label.numberOfLines = 0
        return label
    }()
    
    let displayName: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Display Name"
        tf.font = UIFont.systemFont(ofSize: 26)
        return tf
    }()
    
    let accountTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Account Type"
        label.numberOfLines = 0
        return label
    }()
    
    let accountType: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 26)
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "All settings save when you leave this screen"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account Settings"
        view.backgroundColor = .white
        
        ref = Database.database().reference()

        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let user = Auth.auth().currentUser
        let name = displayName.text!
        ref.child("users").child((user?.uid)!).setValue([ "displayName": name ])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    fileprivate func setupView() {
        view.addSubview(displayNameLabel)
        displayNameLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(displayName)
        displayName.anchor(top: displayNameLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        displayName.delegate = self
        
        view.addSubview(accountTypeLabel)
        accountTypeLabel.anchor(top: displayName.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        view.addSubview(accountType)
        accountType.anchor(top: accountTypeLabel.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 0)
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 24, paddingBottom: -8, paddingRight: 24, width: 0, height: 0)
    }
    
    fileprivate func loadUser() {
        let user = Auth.auth().currentUser
        
        ref.child("users").child((user?.uid)!).child("displayName").observeSingleEvent(of: .value, with: { (snapshot) in
            self.displayName.text = snapshot.value as? String ?? ""
        })
        
        ref.child("users").child((user?.uid)!).child("type").observeSingleEvent(of: .value, with: { (snapshot) in
            self.accountType.text = snapshot.value as? String ?? "Basic"
        })
    }
}
