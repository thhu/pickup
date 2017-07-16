//
//  FriendsViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-13.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    var swipes = 0
    
    @IBOutlet weak var ProfilePic3: UIImageView!
    @IBOutlet weak var ProfilePic2: UIImageView!
    @IBOutlet weak var NoButton: UIButton!
    @IBOutlet weak var YesButton: UIButton!
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Sport1: UIImageView!
    @IBOutlet weak var Sport2: UIImageView!
    @IBOutlet weak var Sport3: UIImageView!
    @IBOutlet weak var Sport4: UIImageView!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var HockeyLevels1: UIImageView!
    @IBOutlet weak var Bio: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*ProfilePic.isHidden = false
        ProfilePic2.isHidden = true
        ProfilePic3.isHidden = true*/
        /*let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(singleTap:)))
        //singleTap.numberOfTapsRequired = 1
        YesButton.isUserInteractionEnabled = true
        YesButton.addGestureRecognizer(singleTap)
        NoButton.isUserInteractionEnabled = true
        NoButton.addGestureRecognizer(singleTap)*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func NoClick(_ sender: Any) {
        /*ProfilePic.isHidden = true
        ProfilePic2.isHidden = true
        ProfilePic3.isHidden = false*/
        ProfilePic.image = #imageLiteral(resourceName: "nancydrew")
        NameLabel.text = "Nancy Drew, 24"
        HockeyLevels1.image = #imageLiteral(resourceName: "hollow")
    }
    
    @IBAction func YesClick(_ sender: Any) {
        /*ProfilePic.isHidden = true
        ProfilePic2.isHidden = false
        ProfilePic3.isHidden = true*/
        ProfilePic.image = #imageLiteral(resourceName: "sarahsmith")
        NameLabel.text = "Sarah Smith, 24"
        HockeyLevels1.image = #imageLiteral(resourceName: "filled")
    }
    
    /*@IBAction func NoClick(_ sender: Any) {
    }
    
    @IBAction func YesClick(_ sender: Any) {
        swipes = swipes + 1
    }*/
    
}
