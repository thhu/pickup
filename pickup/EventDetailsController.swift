//
//  EventDetailsController.swift
//  pickup
//
//  Created by Dan on 2017-06-14.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation

class AttendeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ConfirmedPic: UIImageView!   // Should be check if confirmed, "?" otherwise or something similar
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Name: UILabel!
}

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var Sport: UILabel!
    @IBOutlet weak var HostPic: UIImageView!
    @IBOutlet weak var HostName: UILabel!
    @IBOutlet weak var Location: UILabel!
    @IBOutlet weak var Time: UILabel!
    @IBOutlet weak var SkillLevel: UILabel!
    @IBOutlet weak var Attendees: UITableView!
    
    var eventData: EventData = EventData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Sport.text = eventData.sport
        self.Location.text = eventData.location
        self.Time.text = eventData.time
        self.SkillLevel.text = eventData.skillLevel ?? "All Skill Levels"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
