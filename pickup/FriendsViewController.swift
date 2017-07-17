//
//  FriendsViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-13.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit
import Koloda

private var numberOfCards: Int = 5

class FriendsViewController: UIViewController {
    @IBOutlet weak var kolodaView: KolodaView!
    
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "dp\(index+1)")!)
        }
        
        return array
    }()
    
    // LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // IBACTIONS
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    var swipes = 0
    
    @IBOutlet weak var ProfilePic3: UIImageView!
    @IBOutlet weak var ProfilePic2: UIImageView!
    @IBOutlet weak var NoButton: UIButton!
    @IBOutlet weak var YesButton: UIButton!
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Sport1: UIImageView!
    @IBOutlet weak var Sport2: UIImageView!
    @IBOutlet weak var Sport3: UIImageView!
    @IBOutlet weak var Sport4: UIImageView!
    @IBOutlet weak var Level: UILabel!
    @IBOutlet weak var HockeyLevels1: UIImageView!
    @IBOutlet weak var Bio: UITextView!
    /*override func viewDidLoad() {
        super.viewDidLoad()
        /*ProfilePic.isHidden = false
        ProfilePic2.isHidden = true
        ProfilePic3.isHidden = true*/
        /*let singleTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(singleTap:)))
        //singleTap.numberOfTapsRequired = 1
        YesButton.isUserInteractionEnabled = true
        YesButton.addGestureRecognizer(singleTap)
        NoButton.isUserInteractionEnabled = true
        NoButton.addGestureRecognizer(singleTap)*/
    }*/
    
    
    @IBAction func NoClick(_ sender: Any) {
        /*ProfilePic.isHidden = true
        ProfilePic2.isHidden = true
        ProfilePic3.isHidden = false*/
        ProfilePic.image = #imageLiteral(resourceName: "nancydrew")
        NameLabel.text = "Nancy Drew, 24"
        HockeyLevels1.image = #imageLiteral(resourceName: "hollow")
    }
    
    @IBAction func YesClick(_ sender: Any) {
        /*ProfilePic.isHidden = true
        ProfilePic2.isHidden = false
        ProfilePic3.isHidden = true*/
        ProfilePic.image = #imageLiteral(resourceName: "sarahsmith")
        NameLabel.text = "Sarah Smith, 24"
        HockeyLevels1.image = #imageLiteral(resourceName: "filled")
    }
    
    /*@IBAction func NoClick(_ sender: Any) {
    }
    
    @IBAction func YesClick(_ sender: Any) {
        swipes = swipes + 1
    }*/
    
}

extension FriendsViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        let position = kolodaView.currentCardIndex
        for i in 1...4 {
            dataSource.append(UIImage(named: "dp\(i)")!)
        }
        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
    }
    
    func koloda(koloda: KolodaView, didSelectCardAt index: Int) {
        //handle right swipe
    }
}

extension FriendsViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int
    {
        //return images.count
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed
    {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView
    {
        return UIImageView(image: dataSource[Int(index)])
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView?
    {
        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
        /*return NSBundle.mainBundle().loadNibNamed("OverlayView",
         owner: self, options: nil)[0] as? OverlayView*/
    }
}
