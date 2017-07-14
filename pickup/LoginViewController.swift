//
//  LoginViewController.swift
//  pickup
//
//  Created by Tian Hu on 2017-07-04.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit


class LoginViewController : UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            self.completeLogin(email: self.username.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginButton.readPermissions = ["email"]
        self.fbLoginButton.delegate = self
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if (FBSDKAccessToken.current() == nil){
            print("fb token not found")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.getFBUserData();
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
        print("logout")
    }
    
    func getFBUserData()
    {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                let data:[String:Any] = result as! [String : Any]
                self.completeLogin(email: data["email"] as! String)
            }
        })
    }
    
    func completeLogin(email: String){
        let query = Database.database().reference().child("user").queryLimited(toFirst: 1).queryEqual(toValue: email)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.childrenCount)
            if (snapshot.childrenCount == 0){
                print(1)
                let ref = Database.database().reference().child("user").childByAutoId();
                ref.setValue(email)
            }
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){}
    
    
}
