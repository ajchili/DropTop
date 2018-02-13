import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "If you do not already have an account, one will be created for you when you login."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var handler: AuthStateDidChangeListenerHandle!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
        
        handler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.loadDropView()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handler!)
    }
    
    @objc func handleLogin() {
        if let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") {
            verifyPhoneNumber(verificationID: verificationID)
            return
        }
        
        let alert = UIAlertController(title: "Login", message: "Please enter your phone number.", preferredStyle: .alert)
        alert.addTextField { (textField) -> Void in
            textField.keyboardType = .phonePad
            textField.placeholder = "Phone Number"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: {
            (_) in
            let phoneNumber = alert.textFields?[0].text
            UserDefaults.standard.set(phoneNumber!, forKey: "phoneNumber")
            self.sendVerificationCode(phoneNumber: phoneNumber!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func sendVerificationCode(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber("+1\(phoneNumber)", uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Error: \(error)")
                self.showAlert(title: "There was an error verifying your phone number", description: error.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.verifyPhoneNumber(verificationID: verificationID!)
        }
    }
    
    fileprivate func verifyPhoneNumber(verificationID: String) {
        let alert = UIAlertController(title: "Verification Code", message: "Please enter your verification code.", preferredStyle: .alert)
        alert.addTextField { (textField) -> Void in
            textField.keyboardType = .numberPad
            textField.placeholder = "Verification Code"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: {
            (_) in
            let verificationCode = alert.textFields?[0].text
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode!)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print("Error: \(error)")
                    let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber")
                    self.sendVerificationCode(phoneNumber: phoneNumber!)
                    return
                }
                
                UserDefaults.standard.removeObject(forKey: "authVerificationID")
                self.loadDropView()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func setupView() {
        view.addSubview(loginButton)
        loginButton.centerInView(view: view)
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: -8, paddingRight: 8, width: 0, height: 0)
    }
    
    fileprivate func loadDropView() {
        present(NavigationViewController(), animated: true, completion: nil)
    }
    
    fileprivate func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
