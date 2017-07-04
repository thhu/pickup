//
//  LoginViewController.swift
//  pickup
//
//  Created by Tian Hu on 2017-07-04.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation
import FirebaseAuth


class LoginViewController : UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            // ...
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){}
    
    
}
