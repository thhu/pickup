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
import Kanna
import Alamofire

class HostEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inviteBarBtn: UIBarButtonItem!
    
    @IBOutlet weak var Sport: UIButton!
    @IBOutlet weak var Location: UIButton!
    @IBOutlet weak var Level: UIButton!
    @IBOutlet weak var NumPlayers: UILabel!
    //@IBOutlet weak var AdjustNumPlayers: UIStepper!
    
    @IBOutlet weak var verificationLabel: UILabel!
    
    @IBOutlet weak var detailPickerView: UIView!
    @IBOutlet weak var detailPickerLabel: UILabel!
    @IBOutlet weak var detailsTimePicker: UIDatePicker!
    @IBOutlet weak var detailsMiscPicker: UIPickerView!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
//    @IBOutlet weak var smallPickerView: UIPickerView!
//    @IBOutlet weak var pickerView: UIView!
//    @IBOutlet weak var detailPickerView: UIView!
    
//    @IBOutlet weak var detailPickerLabel: UILabel!
//    @IBOutlet weak var timePicker: UIDatePicker!
    
    let sportDropDown = DropDown()
    let locationDropDown = DropDown()
    let levelDropDown = DropDown()
    
    let sportsData = ["Basketball", "Baseball", "Football", "Badminton", "Soccer"]
    let levelsData = ["All", "Casual", "Novice", "Intermediate", "Advanced"]
    let playersData = ["2", "4", "6", "8", "10"]
    let locData = ["CIF Gym 1", "CIF Gym 2", "PAC Small Gym", "PAC Main Gym", "Warrior Field"]
    
    var pickerData = 0              // 0 => sport, 1 => level, 2 => players, 3 => location
    
    var selectedSport = ""
    var selectedLevel = ""
    var selectedPlayers = "2"
    var selectedDate = Date()
    var selectedStart = Date()
    var selectedEnd = Date()
    
    var sportSet = false
    var levelSet = false
    var playersSet = false
    var dateSet = false
    var startSet = false
    var endSet = false
    var locSet = false
    
    var selectedLoc = ""
    
    var sports = [String]()
    var facilities = [String]()
    var times = [String]()
    
    var ref: DatabaseReference!
    var eventData: Dictionary<String, String>?
    
    @IBAction func chooseSport(_ sender: UIButton) {
        sportDropDown.show()
    }
    
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
        sportDropDown.dataSource = sportsData
        sportDropDown.selectionAction = { [unowned self] (index, item) in
            self.Sport.setTitle(item, for: .normal)
        }
        
        locationDropDown.anchorView = Location
        locationDropDown.dataSource = locData
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
        
        detailPickerView.isHidden = true
        self.eventData = Dictionary()
        
        setupDropDowns()
//        AdjustNumPlayers.value = 2
//        AdjustNumPlayers.maximumValue = 10
        self.ref = Database.database().reference().child("events")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "inviteFriends") {
            let curDate = Date()
            self.eventData?.updateValue("0", forKey: "numAttending")
            self.eventData?.updateValue(String(curDate.timeIntervalSince1970), forKey: "timestamp")
            if let dict = eventData {
                let database = self.ref.childByAutoId()
                database.setValue(dict)
            }
            
            
//            let calendar = NSCalendar.current
//
//            var dateComponents = calendar.dateComponents([.year, .month, .day], from: self.DateTime.date)
//            var sComponents = calendar.dateComponents([.hour, .minute, .second], from: self.StartTime.date)
//            dateComponents.hour = sComponents.hour
//            dateComponents.minute = sComponents.minute
//            dateComponents.second = sComponents.second
//
//            let sDate = calendar.date(from: dateComponents)
//            
//            var eComponents = calendar.dateComponents([.hour, .minute, .second], from: self.EndTime.date)
//            dateComponents.hour = eComponents.hour
//            dateComponents.minute = eComponents.minute
//            dateComponents.second = eComponents.second
//            
//            let eDate = calendar.date(from: dateComponents)
//            let timeString = "\(dateComponents.month!)/\(dateComponents.day!) \(sComponents.hour!):\(sComponents.minute!)-\(eComponents.hour!):\(eComponents.minute!)"
//            
//            var outputs = [String:Any]()
//            outputs["sport"] = self.Sport.currentTitle!
//            outputs["location"] = self.Location.currentTitle!
//            outputs["level"] = self.Level.currentTitle!
//            outputs["numPlayers"] = self.NumPlayers.text!
//            outputs["start"] = sDate!.timeIntervalSince1970
//            outputs["end"] = eDate!.timeIntervalSince1970
//            outputs["time"] = timeString
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Sport"
            case 1:
                cell.textLabel?.text = "Level"
            default:
                cell.textLabel?.text = "Players"
            }
        case 1:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Date"
            case 1:
                cell.textLabel?.text = "Start"
            default:
                cell.textLabel?.text = "End"
            }
        default:
            cell.textLabel?.text = "Location"
        }
        
        //cell.detailTextLabel?.text = "Details"
        //cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        //detailPickerLabel?.text = indexPath.row.
        //let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        //detailPickerLabel.text = cell.textLabel?.text
        //detailPickerView.isHidden = false
        
        switch indexPath.section {
        case 0:
            detailsTimePicker.isHidden = true
            
            switch indexPath.row {
            case 0:
                detailPickerLabel?.text = "Sport"
                pickerData = 0
            case 1:
                detailPickerLabel?.text = "Level"
                pickerData = 1
            default:
                detailPickerLabel?.text = "Players"
                pickerData = 2
            }
            
            detailsMiscPicker.reloadAllComponents()
            detailsMiscPicker.isHidden = false
            okBtn.isEnabled = false
        case 1:
            detailsMiscPicker.isHidden = true
            okBtn.isEnabled = true
            
            switch indexPath.row {
            case 0:
                detailPickerLabel?.text = "Date"
                detailsTimePicker.datePickerMode = UIDatePickerMode.date
                
                let currentDate = Date()
                var dateComponent = DateComponents()
                dateComponent.day = 7
                
                detailsTimePicker.minimumDate = currentDate
                detailsTimePicker.maximumDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                
            case 1:
                detailPickerLabel?.text = "Start"
                detailsTimePicker.datePickerMode = UIDatePickerMode.time
            default:
                detailPickerLabel?.text = "End"
                detailsTimePicker.datePickerMode = UIDatePickerMode.time
            }
            detailsTimePicker.isHidden = false
            
        default:
            //if (sportSet && dateSet && startSet && endSet) {
                scrape(date: selectedDate)
                detailPickerLabel?.text = "Location"
                detailsTimePicker.isHidden = true
                pickerData = 3
                detailsMiscPicker.reloadAllComponents()
                
                //~~~
//                var validIndexes = [Int]()
//                for index in 0...sports.count-1 {
//                    if ((sports[index] == selectedSport) ||
//                        ((sports[index] == "Warrior Field") && (
//                            (selectedSport == "Soccer") ||
//                            (selectedSport == "Football") ||
//                            (selectedSport == "Hockey"))
//                        )) {
//                        validIndexes.append(index)
//                    }
//                }
//                let formatter = DateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd hh:mm a"
//                print(formatter.string(from: selectedDate))
//                print(formatter.string(from: selectedStart))
//                print(formatter.string(from: selectedEnd))
//                for index in validIndexes {
                    
//                    var selectedStartTime = DateComponents()
//                    var selectedEndTime = DateComponents()
//                    let cal = Calendar.current
//                    selectedStartTime = cal.dateComponents([.year, .month, .day], from: selectedDate)
//                    selectedStartTime.hour = cal.dateComponents([.hour], from: selectedStart).hour
//                    selectedStartTime.minute = cal.dateComponents([.minute], from: selectedStart).minute
//                    selectedStart = Calendar.current.
//                    
//                    selectedTime.year = selectedDate.
//                    
//                    var time = times[index]
//                    let index1 = time.index(time.startIndex, offsetBy: 8)
                    
//                }
                //~~~

            
                detailsMiscPicker.isHidden = false
                okBtn.isEnabled = false
            //}
        }
        
        detailPickerView.isHidden = false
    }
    
    @IBAction func cancelClick(_ sender: Any) {
        detailPickerView.isHidden = true
    }
    
    @IBAction func okClick(_ sender: Any) {
        let row = tableView.indexPathForSelectedRow
        let cell = tableView.cellForRow(at: row!)
        
        if let text = cell?.textLabel?.text {
            let formatter = DateFormatter()
            switch text {
            case "Sport":
                cell?.detailTextLabel?.text = selectedSport
                self.eventData?.updateValue(selectedSport, forKey: "sport")
            case "Level":
                cell?.detailTextLabel?.text = selectedLevel
                self.eventData?.updateValue(selectedLevel, forKey: "level")
            case "Players":
                cell?.detailTextLabel?.text = selectedPlayers
                self.eventData?.updateValue(selectedPlayers, forKey: "numPlayers")
            case "Date":
                selectedDate = detailsTimePicker.date
                dateSet = true
                formatter.dateFormat = "MMMM d"
                cell?.detailTextLabel?.text = formatter.string(from: selectedDate)
                formatter.dateFormat = "YYYY-MM-DD"
                self.eventData?.updateValue(formatter.string(from: selectedDate), forKey: "date")
            case "Start":
                selectedStart = detailsTimePicker.date
                startSet = true
                formatter.dateFormat = "h:mm a"
                cell?.detailTextLabel?.text = formatter.string(from: selectedStart)
                self.eventData?.updateValue(String(selectedStart.timeIntervalSince1970), forKey: "start")
                
            case "End":
                selectedEnd = detailsTimePicker.date
                endSet = true
                formatter.dateFormat = "h:mm a"
                cell?.detailTextLabel?.text = formatter.string(from: selectedEnd)
                self.eventData?.updateValue(String(selectedEnd.timeIntervalSince1970), forKey: "end")
            default:
                cell?.detailTextLabel?.text = selectedLoc
                self.eventData?.updateValue(selectedLoc, forKey: "location")
            }
        }
        
        detailPickerView.isHidden = true
        tableView.reloadData()
        
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if (sportSet && dateSet && startSet && endSet && locSet) {
            validateDetails()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerData {
        case 0:
            return sportsData[row]
        case 1:
            return levelsData[row]
        case 2:
            return playersData[row]
        default:
            return locData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        okBtn.isEnabled = true
        
        switch pickerData {
        case 0:
            selectedSport = sportsData[row]
            sportSet = true
        case 1:
            selectedLevel = levelsData[row]
            levelSet = true
        case 2:
            selectedPlayers = playersData[row]
            playersSet = true
        default:
            selectedLoc = locData[row]
            locSet = true
        }
        
    }
    
    func scrape(date: Date) -> Void {
        sports.removeAll()
        facilities.removeAll()
        times.removeAll()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let searchDate = formatter.string(from: selectedDate)
        print("SEARCHING FOR DATE: \(searchDate)")
        
        Alamofire.request("http://webapp.getrecdapp.com/warriorrec/category/79/\(searchDate)/").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(html: String) -> Void {
        if let doc = HTML(html: html, encoding: .utf8) {
            //let row = doc.xpath("//tr[not(th)]")
            let cols = doc.xpath("//td[descendant::a or string-length(text()) > 0]")
            print("COLS count: \(cols.count)")
            for col in 0...cols.count-1 {
                
                let text = cols[col].text
                
                switch (col % 3) {
                case 0:
                    sports.append(text!)
                case 1:
                    facilities.append(text!)
                default:
                    times.append(text!)
                }
                
                print("\(col): \(text)")
            }
        }
        
        print("SPORTS count: \(sports.count)")
        print("FACILITIES count: \(facilities.count)")
        print("TIMES count: \(times.count)")
        
        for element in sports {
            print(element)
        }
        
        for element in facilities {
            print(element)
        }

        for element in times {
            print(element)
        }
    }
    
    func validateDetails() {
        print("SPORTS count: \(sports.count)")
        for index in 0...sports.count-1 {
            if ((sports[index] == selectedSport) ||
                ((sports[index] == "Warrior Field") &&
                    (   (selectedSport == "Soccer") ||
                        (selectedSport == "Football") ||
                        (selectedSport == "Hockey")))   ) {
                let str = facilities[index]
                let index1 = str.index(str.startIndex, offsetBy: 12)
                let facility = str.substring(from: index1)
                if (facility == selectedLoc) {
                    let strTime = times[index]
                    let index2 = strTime.index(strTime.startIndex, offsetBy: 8)
                    let c1str = strTime.substring(to: index2)
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm a"
                    let c1 = formatter.date(from: c1str)
                    let c1comps = Calendar.current.dateComponents([.hour, .minute], from: c1!)
                    let startcomps = Calendar.current.dateComponents([.hour, .minute], from: selectedStart)
                    
                    if (startcomps.hour! > c1comps.hour! ||
                        (startcomps.hour == c1comps.hour && startcomps.minute! >= c1comps.minute!)) {
                        
                        let endTime = times[index]
                        let index3 = endTime.index(endTime.endIndex, offsetBy: -8)
                        let c2str = endTime.substring(from: index3)
                        
                        let c2 = formatter.date(from: c2str)
                        let c2comps = Calendar.current.dateComponents([.hour, .minute], from: c2!)
                        let endcomps = Calendar.current.dateComponents([.hour, .minute], from: selectedEnd)
                        
                        if (endcomps.hour! < c2comps.hour! ||
                            (endcomps.hour == c2comps.hour && endcomps.minute! <= c2comps.minute!)) {
                            verificationLabel.text = ""
                            inviteBarBtn.isEnabled = true
                            return
                        }
                    }
                }
                
                
            }
        }
        verificationLabel.text = "\(selectedLoc) is not available for \(selectedSport) at the selected times"
        inviteBarBtn.isEnabled = false
    }
    
}
