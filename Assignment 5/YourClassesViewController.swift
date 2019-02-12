//
//  YourClassesViewController.swift
//  Assignment 5
//
//  Created by Arzoo Patel on 11/17/18.
//  Copyright © 2018 Arzoo Patel. All rights reserved.
//

import UIKit
import Alamofire

class YourClassesViewController: UIViewController,UITableViewDataSource{
    var tableData : NSDictionary = [:]
    var classesArray : NSArray = []
    var waitlistArray : NSArray = []

    @IBOutlet weak var yourClassesTable: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let redID = defaults.value(forKey: "redID")
        let password = defaults.value(forKey: "password")
        let parameters: Parameters = ["redid": redID!,"password":password!]
        Alamofire.request("https://bismarck.sdsu.edu/registration/studentclasses",method: .get, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                let result = json as! NSDictionary
                let classesIDArray = result.value(forKey: "classes") as! [Int]
                let waitlistIDArray = result.value(forKey: "waitlist") as! [Int]
                let parameters: Parameters = ["classids":  classesIDArray]
                Alamofire.request("https://bismarck.sdsu.edu/registration/classdetails", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
                    if let json = response.result.value {
                        self.classesArray = json as! NSArray
                        let parameters: Parameters = ["classids":  waitlistIDArray]
                        Alamofire.request("https://bismarck.sdsu.edu/registration/classdetails", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
                            if let json = response.result.value {
                                self.waitlistArray = json as! NSArray
                                self.yourClassesTable.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Your registerd Classes"
        }else{
            return "Your Waitlisted Classes"
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return classesArray.count
        }else{
            return waitlistArray.count
        }
    }
    
    @IBAction func removeCourse(_ sender: Any) {
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "classesCell") as! ClassInformationTableViewCell
    
        if indexPath.section == 0{
            
            row.removeCourseButton.addTarget(self, action: #selector(unRegister), for: .touchUpInside)
            
            let rowDictionary  = classesArray[indexPath.row] as! NSDictionary
             row.removeCourseButton.tag = rowDictionary.value(forKey: "id") as! Int
            row.textLabel?.text = "\(rowDictionary.value(forKey: "title")!)"
        }else{
            row.removeCourseButton.addTarget(self, action: #selector(unWaitlist), for: .touchUpInside)
            
            let rowDictionary  = waitlistArray[indexPath.row] as! NSDictionary
            row.removeCourseButton.tag = rowDictionary.value(forKey: "id") as! Int
            row.textLabel?.text = "\(rowDictionary.value(forKey: "title")!)"
        }
        return row
    }

    @IBAction func unRegister(_ sender: UIButton){
        let defaults = UserDefaults.standard
        let redID = defaults.value(forKey: "redID")
        let password = defaults.value(forKey: "password")
        let courseId = sender.tag
        let parameters: Parameters = ["redid": redID!,"password":password!, "courseid":courseId]
        Alamofire.request("https://bismarck.sdsu.edu/registration/unregisterclass",method: .get, parameters: parameters).responseJSON { response in
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
              self.viewDidLoad()
                
            }
        }
    }
    
    @IBAction func unWaitlist(_ sender: UIButton){
        let defaults = UserDefaults.standard
        let redID = defaults.value(forKey: "redID")
        let password = defaults.value(forKey: "password")
        let courseId = sender.tag
        let parameters: Parameters = ["redid": redID!,"password":password!, "courseid":courseId]
        Alamofire.request("https://bismarck.sdsu.edu/registration/unwaitlistclass",method: .get, parameters: parameters).responseJSON { response in
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
                self.viewDidLoad()
                
            }
        }
    }

}
