//
//  EventViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-12.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var Sport: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Time: UILabel!
}

class EventData {
    var key: String!
    var organizer: String!
    var sport: String!
    var location: String!
    var time: String!
    var skillLevel: String?
}

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var eventItems: [EventData] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference().child("events")
        self.ref.observe(.value, with: { snapshot in
            self.eventItems.removeAll()
            for item in snapshot.children {
                let data = item as! DataSnapshot
                let dictionary = data.value as! [String: String]
                
                let eventData = EventData()
                eventData.key = data.key
                eventData.sport = dictionary["sport"]
                eventData.location = dictionary["location"]
                eventData.time = dictionary["time"]
                eventData.skillLevel = dictionary["level"]
                
                self.eventItems.append(eventData)
                self.tableView.reloadData()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath as IndexPath) as! EventTableViewCell
        
        cell.Sport?.text = eventItems[indexPath.row].sport
        cell.Location?.text = eventItems[indexPath.row].location
        cell.Time?.text = eventItems[indexPath.row].time
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.gray.cgColor
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "eventDetails"){
            let index = self.tableView.indexPathForSelectedRow?.row
            let controller = segue.destination as! EventDetailsViewController
            controller.eventData = eventItems[index!]
        }
    }

    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
}
