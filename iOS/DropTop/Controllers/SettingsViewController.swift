//
//  SettingsViewController.swift
//  DropTop
//
//  Created by Kirin Patel on 12/13/17.
//  Copyright © 2017 Kirin Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    @IBOutlet var rememberMe: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
         rememberMe.isOn = AppDelegate.rememberMe
    }
    
    @IBAction func logoutTouchIUpInside(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func rememberMeValueChanged(_ sender: Any) {
        AppDelegate.rememberMe = rememberMe.isOn
    }
}
