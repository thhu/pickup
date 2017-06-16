//
//  HostEventController.swift
//  pickup
//
//  Created by Dan on 2017-06-14.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation
import DropDown

class HostEventViewController: UIViewController {

    @IBOutlet weak var Sport: UIButton!
    @IBOutlet weak var Location: UIButton!
    @IBOutlet weak var Level: UIButton!
    @IBOutlet weak var NumPlayers: UITextField!
    @IBOutlet weak var AdjustNumPlayers: UIStepper!
    
    let sportDropDown = DropDown()
    let locationDropDown = DropDown()
    let levelDropDown = DropDown()
    
    @IBAction func chooseSport(_ sender: UIButton) {
        sportDropDown.show()
    }
    
    @IBAction func chooseLocation(_ sender: UIButton) {
        locationDropDown.show()
    }
    
    @IBAction func chooseLevel(_ sender: UIButton) {
        levelDropDown.show()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
