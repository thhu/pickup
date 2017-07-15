//
//  RegsiterAccountViewController.swift
//  pickup
//
//  Created by Tian Hu on 2017-07-04.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class RegisterAccountViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func registerAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!) { (user, error) in
            if (error == nil){
                let ref = Database.database().reference().child("user").childByAutoId();
                ref.setValue(["email": self.email.text])
                UserDefaults.standard.setValue(ref.key, forKey: "token")
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
