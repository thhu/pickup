//
//  RegsiterAccountViewController.swift
//  pickup
//
//  Created by Tian Hu on 2017-07-04.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation
import FirebaseAuth

class RegisterAccountViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func registerAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            if (error == nil){
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            }
        }
    }
    
}
