//
//  HostEventController.swift
//  pickup
//
//  Created by Dan on 2017-06-14.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation
import DropDown
import FirebaseDatabase

class HostEventViewController: UIViewController {

    @IBOutlet weak var Sport: UIButton!
    @IBOutlet weak var Location: UIButton!
    @IBOutlet weak var Level: UIButton!
    @IBOutlet weak var NumPlayers: UILabel!
    @IBOutlet weak var AdjustNumPlayers: UIStepper!
    
    let sportDropDown = DropDown()
    let locationDropDown = DropDown()
    let levelDropDown = DropDown()
    
    @IBOutlet weak var DateTime: UIDatePicker!
    @IBOutlet weak var StartTime: UIDatePicker!
    @IBOutlet weak var EndTime: UIDatePicker!
    
    var ref: DatabaseReference!
    
    @IBAction func chooseSport(_ sender: UIButton) {
        sportDropDown.show()
    }
    
    @IBOutlet weak var Date: UIDatePicker!
    @IBAction func chooseLocation(_ sender: UIButton) {
        locationDropDown.show()
    }
    
    @IBAction func chooseLevel(_ sender: UIButton) {
        levelDropDown.show()
    }
    
    @IBAction func numPlayerChanged(_ sender: UIStepper) {
        NumPlayers.text = Int(sender.value).description
    }
    
    func setupDropDowns() {
        sportDropDown.anchorView = Sport
        sportDropDown.dataSource = ["Basketball", "Baseball", "Soccer"]
        sportDropDown.selectionAction = { [unowned self] (index, item) in
            self.Sport.setTitle(item, for: .normal)
        }
        
        locationDropDown.anchorView = Location
        locationDropDown.dataSource = ["CIF 1", "CIF 2"]
        locationDropDown.selectionAction = { [unowned self] (index, item) in
            self.Location.setTitle(item, for: .normal)
        }
        
        levelDropDown.anchorView = Level
        levelDropDown.dataSource = ["All Skill Levels", "Beginner", "Intermediate", "Advanced"]
        levelDropDown.selectionAction = { [unowned self] (index, item) in
            self.Level.setTitle(item, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDowns()
        AdjustNumPlayers.value = 2
        AdjustNumPlayers.maximumValue = 10
        self.ref = Database.database().reference().child("events")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "inviteFriends") {
            let database = self.ref.childByAutoId()
            
            let calendar = NSCalendar.current

            var dateComponents = calendar.dateComponents([.year, .month, .day], from: self.DateTime.date)
            var sComponents = calendar.dateComponents([.hour, .minute, .second], from: self.StartTime.date)
            dateComponents.hour = sComponents.hour
            dateComponents.minute = sComponents.minute
            dateComponents.second = sComponents.second

            let sDate = calendar.date(from: dateComponents)
            
            var eComponents = calendar.dateComponents([.hour, .minute, .second], from: self.EndTime.date)
            dateComponents.hour = eComponents.hour
            dateComponents.minute = eComponents.minute
            dateComponents.second = eComponents.second
            
            let eDate = calendar.date(from: dateComponents)
            let timeString = "\(dateComponents.month!)/\(dateComponents.day!) \(sComponents.hour!):\(sComponents.minute!)-\(eComponents.hour!):\(eComponents.minute!)"
            
            var outputs = [String:Any]()
            outputs["sport"] = self.Sport.currentTitle!
            outputs["location"] = self.Location.currentTitle!
            outputs["level"] = self.Level.currentTitle!
            outputs["numPlayers"] = self.NumPlayers.text!
            outputs["start"] = sDate!.timeIntervalSince1970
            outputs["end"] = eDate!.timeIntervalSince1970
            outputs["time"] = timeString
            
            database.setValue(outputs)
        }
    }
}
