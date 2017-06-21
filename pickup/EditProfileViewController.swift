//
//  ProfileViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-13.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EditProfileViewController: UIViewController {
    @IBOutlet weak var Confirm: UIBarButtonItem!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Bio: UITextView!
    
    var key: String?
    var ref: DatabaseReference!
    var profile: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference().child("profile")
        self.ref.observe(.value, with: { snapshots in
            let snapshot = snapshots.children.nextObject() as? DataSnapshot
            self.key = snapshot?.key
            let dict = (snapshots.children.nextObject() as? DataSnapshot)?.value as? [String: String]
            if dict != nil {
                self.profile = ProfileData()
                self.profile?.firstName = dict?["firstName"]
                self.profile?.lastName = dict?["lastName"]
                self.profile?.bio = dict?["bio"]
                
                self.FirstName.text = self.profile?.firstName
                self.LastName.text = self.profile?.lastName
                self.Bio.text = self.profile?.bio
            }
        })
    }
    
    @IBAction func confirmChanges(_ sender: Any) {
        let newProfile = [
            "firstName": FirstName.text ?? "",
            "lastName": LastName.text ?? "",
            "bio": Bio.text ?? ""
        ]
        if self.key != nil {
            self.ref.child(self.key!).setValue(newProfile)
        } else {
            self.ref.childByAutoId().setValue(newProfile)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
