//
//  CourseViewController.swift
//  Assignment 5
//
//  Created by Arzoo Patel on 11/15/18.
//  Copyright © 2018 Arzoo Patel. All rights reserved.
//

import UIKit
import Alamofire

class CourseViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var filter: UIPickerView!
    @IBOutlet weak var coursesTable: UITableView!
    
    var majorListData : NSArray = []
    var tableData: NSArray = []
    let levelPickerView = ["All","lower","upper","graduate"]
    let startTimePickerView = [730,830,930,1030,1130,1230,1330,1430,1530,1630,1730,1830,1930]
    var selectedMajorRow: Int = 0
    var majorId : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filter.selectRow(selectedMajorRow, inComponent: 0, animated: true) 
        let parameters: Parameters = ["subjectid": majorId]
        Alamofire.request("https://bismarck.sdsu.edu/registration/classidslist",method: .get, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                let parameters: Parameters = ["classids":  json]
                Alamofire.request("https://bismarck.sdsu.edu/registration/classdetails", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
                   if let json = response.result.value {
                        self.tableData = json as! NSArray
                        self.coursesTable.reloadData()
                    }
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return majorListData.count
        }
        else if component == 1{
            return levelPickerView.count
        }
        else{
            return startTimePickerView.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        if component == 0{
            let rowDictionary  = majorListData[row] as! NSDictionary
            return "\(rowDictionary.value(forKey: "title")!)"
        }
        else if component == 1{
            return levelPickerView[row]
            
        }else{
            let time = startTimePickerView[row]
            return "\(time/100):\(time%100)"
        }
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if component == 0{
            return screenWidth * 0.55
        }
        else if component == 1{
            return screenWidth * 0.20
            
        }else{
            return screenWidth * 0.20
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        let rowDictionary  = majorListData[ pickerView.selectedRow(inComponent: 0)] as! NSDictionary
        let subjectID = rowDictionary.value(forKey: "id")!
        let level = levelPickerView[pickerView.selectedRow(inComponent: 1)]
        let startTime = startTimePickerView[pickerView.selectedRow(inComponent: 2)]
        let parameters: Parameters = ["subjectid": subjectID,"level":level,"starttime":startTime]
        Alamofire.request("https://bismarck.sdsu.edu/registration/classidslist",method: .get, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                let parameters: Parameters = ["classids":  json]
                Alamofire.request("https://bismarck.sdsu.edu/registration/classdetails", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
                    if let json = response.result.value {
                        self.tableData = json as! NSArray
                        self.coursesTable.reloadData()
                    }
                }
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
        let courseId = (tableData[indexPath.row] as! NSDictionary).value(forKey: "id")
        performSegue(withIdentifier: "forCourseInformation", sender: courseId)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "forCourseInformation") {
            let courseInformationViewController = segue.destination as! CourseInformationViewController
            courseInformationViewController.courseId = sender as! Int
        }
    }
    @IBAction func backToCourses(unwindSegue:UIStoryboardSegue){
        
    }
}
