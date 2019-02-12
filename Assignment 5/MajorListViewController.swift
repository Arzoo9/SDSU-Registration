//
//  MajorListViewController.swift
//  Assignment 5
//
//  Created by Arzoo Patel on 11/15/18.
//  Copyright © 2018 Arzoo Patel. All rights reserved.
//

import UIKit
import Alamofire

class MajorListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var tableData: NSArray = []
    
    @IBOutlet weak var majorTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        Alamofire.request("https://bismarck.sdsu.edu/registration/subjectlist",method: .get).responseJSON { response in
            if let json = response.result.value {
                self.tableData = json as! NSArray
                self.majorTable.reloadData()
            }
        }
       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = UITableViewCell()
        let rowDictionary  = tableData[indexPath.row] as! NSDictionary
        row.textLabel?.text = "\(rowDictionary.value(forKey: "title")!)"
        return row
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let majorId = (tableData[indexPath.row] as! NSDictionary).value(forKey: "id")
        performSegue(withIdentifier: "forCourses", sender: indexPath)
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "forCourses") {
            let majorId = (tableData[(sender as! IndexPath).row] as! NSDictionary).value(forKey: "id")
            let courseViewController = segue.destination as! CourseViewController
            courseViewController.majorId = majorId as! Int
            courseViewController.majorListData = tableData
            courseViewController.selectedMajorRow = (sender as! IndexPath).row
        }
    }
    @IBAction func backToMajors(unwindSegue:UIStoryboardSegue){
        
    }
    

}
