//
//  ProfileViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-13.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit
import Foundation
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
    var lvl1: Int!
    var lvl2: Int!
    var lvl3: Int!
    var lvl4: Int!
    var bio: String?
}

class ProfileViewController: UIViewController {


    @IBOutlet weak var FullName: UITextField!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Bio: UITextView!
    @IBOutlet var sport1dots: Array<UIImageView>?
    @IBOutlet var sport2dots: Array<UIImageView>?
    @IBOutlet var sport3dots: Array<UIImageView>?
    @IBOutlet var sport4dots: Array<UIImageView>?
    
    
    var ref: DatabaseReference!
    var profile: ProfileData?
    var lvls = [0, 0, 0, 0]
    var key: String?
    
    
    @IBAction func Sport1But(_ sender: Any) {
        if (lvls[0] == 3) {
            lvls[0] = 0
            for img in self.sport1dots! {
                img.isHidden = true;
            }
        }
        else {
            lvls[0] += 1
            self.sport1dots?[lvls[0]-1].isHidden = false
        }
    }
    
    @IBAction func Sport2But(_ sender: UIButton) {
        if (lvls[1] == 3) {
            lvls[1] = 0
            for img in self.sport2dots! {
                img.isHidden = true;
            }
        }
        else {
            lvls[1] += 1
            self.sport2dots?[lvls[1]-1].isHidden = false
        }
    }
    
    @IBAction func Sport3But(_ sender: UIButton) {
        if (lvls[2] == 3) {
            lvls[2] = 0
            for img in self.sport3dots! {
                img.isHidden = true;
            }
        }
        else {
            lvls[2] += 1
            self.sport3dots?[lvls[2]-1].isHidden = false
        }
    }
    
    @IBAction func Sport4But(_ sender: UIButton) {
        if (lvls[3] == 3) {
            lvls[3] = 0
            for img in self.sport4dots! {
                img.isHidden = true;
            }
        }
        else {
            lvls[3] += 1
            self.sport4dots?[lvls[3]-1].isHidden = false
        }
    }
    
    @IBAction func confirmChanges(_ sender: Any) {
        let fName = FullName.text?.components(separatedBy: " ")
        let newProfile = [
            "firstName": fName?[0] ?? "",
            "lastName": fName?[1] ?? "",
            "bio": Bio.text ?? "",
            "lvl1": lvls[0],
            "lvl2": lvls[1],
            "lvl3": lvls[2],
            "lvl4": lvls[3]
        ] as [String : Any]
         self.ref.updateChildValues(newProfile)
    }

    func updateDots(i: Int, dots: Array<UIImageView>) {
        var j = 0
        for img in dots {
            if (j < i) {
                img.isHidden = false
            }
            else {
                img.isHidden = true
            }
            j += 1
        }
    }
    
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
                self.profile?.lvl1 = ((dict?["lvl1"]) != nil) ? Int((dict?["lvl1"])!) : 0
                self.profile?.lvl2 = ((dict?["lvl2"]) != nil) ? Int((dict?["lvl2"])!) : 0
                self.profile?.lvl3 = ((dict?["lvl3"]) != nil) ? Int((dict?["lvl3"])!) : 0
                self.profile?.lvl4 = ((dict?["lvl4"]) != nil) ? Int((dict?["lvl4"])!) : 0
                self.lvls = [(self.profile?.lvl1)!, (self.profile?.lvl2)!, (self.profile?.lvl3)!, (self.profile?.lvl4)!]
                self.updateDots(i: self.lvls[0], dots: self.sport1dots!)
                self.updateDots(i: self.lvls[1], dots: self.sport2dots!)
                self.updateDots(i: self.lvls[2], dots: self.sport3dots!)
                self.updateDots(i: self.lvls[3], dots: self.sport4dots!)
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
