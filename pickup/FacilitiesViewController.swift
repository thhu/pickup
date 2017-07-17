//
//  FacilitiesViewController.swift
//  pickup
//
//  Created by Jasvin Baweja on 2017-06-27.
//  Copyright © 2017 CS446. All rights reserved.
//

import UIKit
import Kanna
import Alamofire

class FacilitiesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrape()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrape() -> Void {
        Alamofire.request("http://webapp.getrecdapp.com/warriorrec/category/79/2017-06-27/").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(html: String) -> Void {
        if let doc = HTML(html: html, encoding: .utf8) {
            for row in doc.xpath("//tr[not(th)]") {
                let cols = row.xpath("//td[descendant::a or string-length(text()) > 0]")
                for col in 0...cols.count-1 {
                    print(cols[col].text)
                }
                
                
                /*for col in row.xpath("//td[descendant::a or string-length(text()) > 0]") {
                    print(col.text)
                }*/
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
