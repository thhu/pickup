//
//  EditAvailabilityViewController.swift
//  pickup
//
//  Created by Dan on 2017-07-05.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit
import JTAppleCalendar
import FirebaseDatabase
import FirebaseAuth

class AvailTableViewCell: UITableViewCell {
    @IBOutlet weak var timeBlock: UILabel!
}

class EditAvailabilityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var time1: UIDatePicker!
    @IBOutlet weak var time2: UIDatePicker!
    @IBOutlet weak var availTable: UITableView!
    
    let white = UIColor(colorWithHexValue: 0xECEAED)
    let darkPurple = UIColor(colorWithHexValue: 0x3A284C)
    let dimPurple = UIColor(colorWithHexValue: 0x574865)
    
    var ref: DatabaseReference!
    var timeBlocks = [DateInterval]()
    let formatter = DateFormatter()
    

    @IBAction func addAvail(_ sender: Any) {
        let block = DateInterval(start: time1.date, end: time2.date)
        self.timeBlocks.append(block)
        self.availTable.reloadData()
    }
    
    @IBAction func saveAvail(_ sender: Any) {
        let newBlocks = ["availability": timeBlocks] as [String : [DateInterval]]
        self.ref.updateChildValues(newBlocks)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ref.observe(.value, with: { snapshots in
            print(snapshots)
            if let dict = snapshots.value as? [String: Any]{
                self.timeBlocks = (dict["availability"] as? [DateInterval])!
            }
            
        })
        availTable.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let token = UserDefaults.standard.string(forKey: "token") {
            self.ref = Database.database().reference().child("user").child(token).child("availability")
        } else {
            self.ref = Database.database().reference().child("profile")
        }
        
        formatter.dateFormat = "HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "JTCalCellView") // Registering your cell is manditory
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.selectDates([Date.init()])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = darkPurple
            self.time1.setDate(calendarView.selectedDates[0], animated: false)
            self.time2.setDate(calendarView.selectedDates[0], animated: false)
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.dayLabel.textColor = white
            } else {
                myCustomCell.dayLabel.textColor = dimPurple
            }
        }
    }
    
    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
        if cellState.isSelected {
            myCustomCell.selectedView.layer.cornerRadius =  20
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var i = 0
        for blk in timeBlocks {
            if (Calendar.current.isDate(blk.start, inSameDayAs:calendarView.selectedDates[0])) {
                i += 1
            }
        }
        return i
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "availCell", for: indexPath as IndexPath) as! AvailTableViewCell
        
        let todayBlocks = timeBlocks.filter({ Calendar.current.isDate($0.start, inSameDayAs:calendarView.selectedDates[0]) })
        cell.timeBlock?.text = formatter.string(from: todayBlocks[indexPath.row].start) + " to " + formatter.string(from: todayBlocks[indexPath.row].end)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let todayBlocks = timeBlocks.filter({ Calendar.current.isDate($0.start, inSameDayAs:calendarView.selectedDates[0]) })
            let idx = timeBlocks.index(of: todayBlocks[indexPath.row])
            timeBlocks.remove(at: idx!)
            availTable.reloadData()
        }
    }
}

extension EditAvailabilityViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2017 07 01")! // You can use date generated from a formatter
        let endDate = formatter.date(from: "2100 02 01")!                                // You can also use dates created from this function
        let calendar = Calendar.current                     // Make sure you set this up to your time zone. We'll just use default here
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: calendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        availTable.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        handleCellSelection(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
