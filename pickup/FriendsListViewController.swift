//
//  FriendsListViewController.swift
//  pickup
//
//  Created by Dan on 2017-06-16.
//  Copyright © 2017 CS446. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FriendsListViewCell: UITableViewCell {
    
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var Name: UILabel!
}

class UserData {
    var key: String!
    var firstName: String!
    var lastName: String!
    var pictureUrl: String?
    var image: UIImage?
}

class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var FriendsTable: UITableView!
    
    var ref: DatabaseReference!
    var userItems: [UserData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference().child("user")
        self.FriendsTable.delegate = self
        self.FriendsTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            self.userItems.removeAll()
            var itemIndex: Int = 0;
            for item in snapshot.children {
                let datasnapshot = item as! DataSnapshot
                let dict = datasnapshot.value as! [String: Any]
                let data = UserData()
                data.firstName = dict["firstName"] as! String
                data.lastName = dict["lastName"] as! String
                data.pictureUrl = dict["pictureUrl"] as? String
                if let url = data.pictureUrl {
                    self.loadProfilePicture(url: url, index: itemIndex)
                }
                self.userItems.append(data)
                itemIndex = itemIndex + 1
            }
            self.FriendsTable.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.ref.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath as IndexPath) as! FriendsListViewCell
        cell.Name.text = userItems[indexPath.row].firstName + " " + userItems[indexPath.row].lastName
        if let img = userItems[indexPath.row].image {
            cell.ProfilePic.image = img
        }
        return cell
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
                    self.FriendsTable.reloadData()
                }
            }
            
        }
    }
    
}
