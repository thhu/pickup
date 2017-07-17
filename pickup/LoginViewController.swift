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
            self.completeLogin(email: self.username.text!, pictureUrl: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginButton.readPermissions = ["email"]
        self.fbLoginButton.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        if(Auth.auth().currentUser != nil){
            self.dismiss(animated: true, completion: nil)
        }
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
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                let data:[String: Any] = result as! [String: Any]
                print(data)
                if let imageURL = ((data["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    self.completeLogin(email: data["email"] as! String, pictureUrl: imageURL)
                } else {
                    self.completeLogin(email: data["email"] as! String, pictureUrl: "")
                }
            }
        })
    }
    
    func completeLogin(email: String, pictureUrl: String){
        let query = Database.database().reference().child("user").queryOrdered(byChild: "email").queryEqual(toValue: email)
        query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if (snapshot.childrenCount == 0){
                print(pictureUrl)
                let ref = Database.database().reference().child("user").childByAutoId();
                ref.setValue(["email": email, "pictureUrl": pictureUrl])
                UserDefaults.standard.setValue(ref.key, forKey: "token")
                UserDefaults.standard.setValue(pictureUrl, forKey: "profilePictureUrl")
            } else if (snapshot.childrenCount == 1) {
                for child in snapshot.children {
                    UserDefaults.standard.setValue((child as! DataSnapshot).key, forKey: "token")
                }
                
            }
            UserDefaults.standard.synchronize()
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){}
    
    
}
