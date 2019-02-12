//
//  CourseInformationViewController.swift
//  Assignment 5
//
//  Created by Arzoo Patel on 11/15/18.
//  Copyright © 2018 Arzoo Patel. All rights reserved.
//

import UIKit
import Alamofire

class CourseInformationViewController: UIViewController, UITableViewDataSource{
    
    var tableData : NSDictionary = [:]
    var allKeys : NSArray = []
    @IBOutlet weak var courseInformationTable: UITableView!
    var courseId : Int = 0
    var isWaitlisted : Bool = false
    
    @IBOutlet weak var registerClassButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let parameters: Parameters = ["classid": courseId]
        Alamofire.request("https://bismarck.sdsu.edu/registration/classdetails",method: .get, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                let courseInformationDictnoary = json as! NSDictionary
                let waitlist = courseInformationDictnoary.value(forKey: "waitlist") as! Int
                self.isWaitlisted = waitlist > 0 ? true : false
                if self.isWaitlisted{
                    self.registerClassButton.setTitle("Waitlist Class", for: .normal)
                    self.registerClassButton.setTitleColor(UIColor.red, for: .normal)
                }
                
                self.tableData =  courseInformationDictnoary
                self.allKeys = self.tableData.allKeys as NSArray
                self.courseInformationTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.allKeys.count
        
    }
    
    @IBAction func registerForClass(_ sender: Any) {
        let defaults = UserDefaults.standard
        let redID = defaults.value(forKey: "redID")
        let password = defaults.value(forKey: "password")
        let parameters: Parameters = ["redid": redID!,"password":password!, "courseid":courseId]
        let requestString : String
        if isWaitlisted {
            requestString = "https://bismarck.sdsu.edu/registration/waitlistclass"
        }else{
            requestString = "https://bismarck.sdsu.edu/registration/registerclass"
        }
        
        Alamofire.request(requestString,method: .get, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                let result = json as! Dictionary<String,String>
                var messege : String
                
                if result["ok"] != nil{
                    messege = result["ok"]!
                }else{
                    messege = result["error"]!
                }
                let alert = UIAlertView.init(
                    title: "",
                    message: messege,
                    delegate: self,
                    cancelButtonTitle: "Cancel")
                alert.show()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = UITableViewCell()
        let key = "\(allKeys[indexPath.row])"
        row.textLabel?.text = "\(key) - \(tableData.value(forKey: key)!)"
        return row
    }


}
