//
//  TabViewController.swift
//  DropTop
//
//  Created by Kirin Patel on 12/13/17.
//  Copyright © 2017 Kirin Patel. All rights reserved.
//

import UIKit
import FirebaseAuth

class TabViewController: UITabBarController {
    
    var handler: AuthStateDidChangeListenerHandle!

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
