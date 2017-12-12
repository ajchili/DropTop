//
//  LoginViewController.swift
//  DropTop
//
//  Created by Kirin Patel on 12/11/17.
//  Copyright © 2017 Kirin Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var rememberMe: UISwitch!
    
    var handler: AuthStateDidChangeListenerHandle!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                if (user?.isEmailVerified)! {
                    AppDelegate.rememberMe = self.rememberMe.isOn
                } else {
                    let alert = UIAlertController(title: "Your email address has not been verified!", message: "Please complete your registration by verifying your email address.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: {
                        do {
                            try Auth.auth().signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    })
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handler!)
    }

    @IBAction func loginTouchUpInside(_ sender: Any) {
        let email = emailAddress.text!
        let pass = password.text!
        
        if email.count > 0 && pass.count > 0 {
            if email.index(of: "@") == nil || email.index(of: ".") == nil {
                showAlert(title: "Invalid email address!", description: "Please provide a valid email address!")
            } else {
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    if error.debugDescription != "nil" {
                        self.showAlert(title: "Whoops something went wrong!", description: error!.localizedDescription)
                    }
                }
            }
        } else {
            showAlert(title: "Missing information!", description: "Please fill out all fields!")
        }
    }
    
    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
