//
//  FriendsListViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-16.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation

class FriendsListViewCell: UITableViewCell {
    
    @IBOutlet weak var ProfilePic: UIView!
    @IBOutlet weak var Name: UILabel!
}

class FriendsListViewController: UIViewController {
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var FriendsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
