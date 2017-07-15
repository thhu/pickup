//
//  ProfileViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-13.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit

class ProfileSportData {
    var sport: String! //we probably want an enum
    var level: String! //ditto
}

class ProfileData {
    var firstName: String!
    var lastName: String!
    //var sports: Array<ProfileSportData>
    //var time: ??? //unknown format
    var bio: String?
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var FullName: UILabel!
    
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Sport1: UIImageView!
    @IBOutlet weak var Sport2: UIImageView!
    @IBOutlet weak var Sport3: UIImageView!
    @IBOutlet weak var Sport4: UIImageView!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var Bio: UITextView!
    
    var ref: DatabaseReference!
    var profile: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference().child("user").child(UserDefaults.standard.string(forKey: "token")!)
        self.ref.observe(.value, with: { snapshots in
            let dict = snapshots.value as? [String: String]
            if dict != nil {
                self.profile = ProfileData()
                self.profile?.firstName = dict?["firstName"]
                self.profile?.lastName = dict?["lastName"]
                self.profile?.bio = dict?["bio"]
                self.FullName.text = "\(self.profile?.firstName ?? "") \(self.profile?.lastName ?? "")"
                self.Bio.text = self.profile?.bio
            }
        })
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        if (FBSDKAccessToken.current() != nil){
            FBSDKAccessToken.setCurrent(nil)
        }
        
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
        
        var loginView: UIStoryboard!
        loginView = UIStoryboard(name: "Login", bundle: nil)
        let viewcontroller : UIViewController = loginView.instantiateViewController(withIdentifier: "LoginView") as UIViewController
        self.present(viewcontroller, animated: true, completion: nil)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
