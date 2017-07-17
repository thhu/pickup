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
    
    @IBOutlet weak var Sport: UIButton!
    @IBOutlet weak var Location: UIButton!
    @IBOutlet weak var Level: UIButton!
    @IBOutlet weak var NumPlayers: UILabel!
    @IBOutlet weak var AdjustNumPlayers: UIStepper!
    
    @IBOutlet weak var checkBtn: UIButton!
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
    let locData = ["CIF Gym 1", "CIF Gym 2", "PAC Small Gym", "PAC Main Gym", "Warrior Field"]
    
    var pickingSport = true                 //if not picking sport, picking location implied
    
    var selectedSport = ""
    var selectedDate = Date()
    var selectedStart = Date()
    var selectedEnd = Date()
    var sportSet = false
    var dateSet = false
    var startSet = false
    var endSet = false
    
    var selectedLoc = ""
    
    var sports = [String]()
    var facilities = [String]()
    var times = [String]()
    
    var ref: DatabaseReference!
    
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
            database.setValue(["sport": self.Sport.currentTitle,
                               "location": self.Location.currentTitle,
                               "level": self.Level.currentTitle,
                               "numPlayers": self.NumPlayers.text])
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
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
            cell.textLabel?.text = "Sport"
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
            detailPickerLabel?.text = "Sport"
            detailsTimePicker.isHidden = true
            pickingSport = true
            detailsMiscPicker.reloadAllComponents()
            detailsMiscPicker.isHidden = false
            okBtn.isEnabled = false
        case 1:
            detailsMiscPicker.isHidden = true
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
                pickingSport = false
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
            case "Date":
                selectedDate = detailsTimePicker.date
                dateSet = true
                formatter.dateFormat = "MMMM d"
                cell?.detailTextLabel?.text = formatter.string(from: selectedDate)
            case "Start":
                selectedStart = detailsTimePicker.date
                startSet = true
                formatter.dateFormat = "h:mm a"
                cell?.detailTextLabel?.text = formatter.string(from: selectedStart)
            case "End":
                selectedEnd = detailsTimePicker.date
                endSet = true
                formatter.dateFormat = "h:mm a"
                cell?.detailTextLabel?.text = formatter.string(from: selectedEnd)
            default:
                cell?.detailTextLabel?.text = selectedLoc
            }
        }
        
        detailPickerView.isHidden = true
        tableView.reloadData()
        
//        if (detailsMiscPicker.isHidden) {
//            let formatter = DateFormatter()
//            
//            formatter.dateFormat = "h:mm a"
//            cell?.detailTextLabel?.text = formatter.string(from: detailsTimePicker.date)
//        } else {
//            cell?.textLabel?.text = selected
//        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickingSport) {
            return sportsData[row]
        } else {
            return locData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        okBtn.isEnabled = true
        if (pickingSport) {
            selectedSport = sportsData[row]
            sportSet = true
        } else {
            selectedLoc = locData[row]
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
    
    @IBAction func checkClick(_ sender: Any) {
        print("SPORTS count: \(sports.count)")
        //var valid = false
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
                            verificationLabel.text = "YES"
                            return
                        }
                    }
                }
    
    
            }
        }
        verificationLabel.text = "NO"
    }
    
}
