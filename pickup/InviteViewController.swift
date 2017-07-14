//
//  InviteViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-15.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation
import UserNotifications

class InviteViewCell: UITableViewCell {
    
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Name: UILabel!
}


class InviteViewController: UIViewController {
    
    
    @IBOutlet weak var NonFriends: UILabel!
    @IBOutlet weak var FriendsInvited: UILabel!
    @IBOutlet weak var SearchFriends: UISearchBar!
    @IBOutlet weak var InviteFriendsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func Send(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToEventViewController", sender: self)
    }
}
