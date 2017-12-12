//
//  RegisterViewController.swift
//  DropTop
//
//  Created by Kirin Patel on 12/11/17.
//  Copyright © 2017 Kirin Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var verifyPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailAddress.text = ""
        password.text = ""
        verifyPassword.text = ""
    }

    @IBAction func cancelTouchUpInside(_ sender: Any) {
        close()
    }
    
    @IBAction func closeTouchUpInside(_ sender: Any) {
        close()
    }
    
    @IBAction func registerTouchUpInside(_ sender: Any) {
        let email = emailAddress.text!
        let pass = password.text!
        let vpass = verifyPassword.text!
        
        if email.count > 0 && pass.count > 0 && vpass.count > 0 {
            if email.index(of: "@") == nil || email.index(of: ".") == nil {
                showAlert(title: "Invalid email address!", description: "Please provide a valid email address!")
            } else if pass != vpass {
                showAlert(title: "Passwords do not match!", description: "Please make sure you provide the same password for both fields!")
            } else {
                Auth.auth().createUser(withEmail: email, password: vpass) { (user, error) in
                    if error.debugDescription != "nil" {
                        self.showAlert(title: "Whoops something went wrong!", description: error!.localizedDescription)
                    } else {
                        Auth.auth().currentUser?.sendEmailVerification { (error) in
                            if error.debugDescription != "nil" {
                                self.showAlert(title: "Whoops something went wrong!", description: error!.localizedDescription)
                            } else {
                                let alert = UIAlertController(title: "Your account has been created!", message: "Please complete your registration by verifying your email address.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                                    (_)in
                                    self.close()
                                    self.close()
                                }))
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
            }
        } else {
            showAlert(title: "Missing information!", description: "Please fill out all fields!")
        }
    }
    
    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func close() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
