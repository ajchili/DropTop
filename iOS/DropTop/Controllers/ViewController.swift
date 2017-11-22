//
//  ViewController.swift
//  DropTop
//
//  Created by Kirin Patel on 11/22/17.
//  Copyright © 2017 Kirin Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var emailEntry: UITextField!
    @IBOutlet var passwordEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButton(_ sender: Any) {
        print("User entered \(emailEntry.text!)")
        print("User entered \(passwordEntry.text!)")
    }
    
}

