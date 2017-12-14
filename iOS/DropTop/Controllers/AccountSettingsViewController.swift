//
//  AccountSettingsViewController.swift
//  DropTop
//
//  Created by Kirin Patel on 12/13/17.
//  Copyright © 2017 Kirin Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountSettingsViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Account Settings"
    }
}
