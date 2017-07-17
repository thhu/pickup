//
//  FriendsViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-13.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit
import Koloda
import FirebaseDatabase

private var numberOfCards: Int = 5

class ProfileData2 {
    var firstName: String!
    var lastName: String!
    var lvl1: Int!
    var lvl2: Int!
    var lvl3: Int!
    var lvl4: Int!
    var bio: String?
    var imageUrl: String?
    var image: UIImage?
}

class FriendsViewController: UIViewController {
    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet var sport1dots: Array<UIImageView>?
    @IBOutlet var sport2dots: Array<UIImageView>?
    @IBOutlet var sport3dots: Array<UIImageView>?
    @IBOutlet var sport4dots: Array<UIImageView>?
    
    var ref: DatabaseReference!
    var userItems: [ProfileData2] = []
    var itemIdx = 0
    fileprivate var dataSource: [UIImage] = []
    
    func updateDots(i: Int, dots: Array<UIImageView>) {
        var j = 0
        for img in dots {
            if (j < i) {
                img.isHidden = false
            }
            else {
                img.isHidden = true
            }
            j += 1
        }
    }
    
    // LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.ref = Database.database().reference().child("user")
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemIdx = 0
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            self.userItems.removeAll()
            var itemIndex: Int = 0;
            for item in snapshot.children {
                let datasnapshot = item as! DataSnapshot
                let dict = datasnapshot.value as! [String: Any]
                let data = ProfileData2()
                data.firstName = dict["firstName"] as! String
                data.lastName = dict["lastName"] as! String
                data.bio = dict["bio"] as! String
                data.imageUrl = dict["pictureUrl"] as? String
                data.lvl1 = ((dict["lvl1"]) != nil) ? Int((dict["lvl1"] as! Int)) : 0
                data.lvl2 = ((dict["lvl2"]) != nil) ? Int((dict["lvl2"] as! Int)) : 0
                data.lvl3 = ((dict["lvl3"]) != nil) ? Int((dict["lvl3"] as! Int)) : 0
                data.lvl4 = ((dict["lvl4"]) != nil) ? Int((dict["lvl4"] as! Int)) : 0
                if let url = data.imageUrl {
                    self.loadProfilePicture(url: url, index: itemIndex)
                }
                self.userItems.append(data)
                itemIndex = itemIndex + 1
                
            }
            self.Bio.text = self.userItems[0].bio
            self.NameLabel.text = "\(self.userItems[0].firstName ?? "") \(self.userItems[0].lastName ?? "")"
            self.updateDots(i: self.userItems[0].lvl1, dots: self.sport1dots!)
            self.updateDots(i: self.userItems[0].lvl2, dots: self.sport2dots!)
            self.updateDots(i: self.userItems[0].lvl3, dots: self.sport3dots!)
            self.updateDots(i: self.userItems[0].lvl4, dots: self.sport4dots!)
        })
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeAllObservers()
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
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func loadProfilePicture(url: String, index: Int){
        if let picUrl = URL(string: url) {
            getDataFromUrl(url: picUrl) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? picUrl.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                    self.userItems[index].image = UIImage(data: data)
                    self.dataSource.append(self.userItems[index].image!)
                    self.kolodaView.reloadData()
                }
            }
            
        }
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
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAt index: Int) {
        //handle right swipe
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if (self.itemIdx == 2) {
            self.itemIdx = 0
        } else {
        self.itemIdx += 1
        }
        self.Bio.text = self.userItems[self.itemIdx].bio
        self.NameLabel.text = "\(self.userItems[self.itemIdx].firstName ?? "") \(self.userItems[self.itemIdx].lastName ?? "")"
        self.updateDots(i: self.userItems[self.itemIdx].lvl1, dots: self.sport1dots!)
        self.updateDots(i: self.userItems[self.itemIdx].lvl2, dots: self.sport2dots!)
        self.updateDots(i: self.userItems[self.itemIdx].lvl3, dots: self.sport3dots!)
        self.updateDots(i: self.userItems[self.itemIdx].lvl4, dots: self.sport4dots!)
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
