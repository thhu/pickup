//
//  EventViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-12.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var Sport: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Time: UILabel!
}

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath as IndexPath) as! EventTableViewCell
        
        cell.Sport?.text = "Basketball"
        cell.Location?.text = "CIF 2"
        cell.Time?.text = "Jun 16 6:00pm-7:30pm"
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        
        return cell
    }

    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
}
