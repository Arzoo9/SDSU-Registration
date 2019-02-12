//
//  ViewController.swift
//  Assignment 5
//
//  Created by Arzoo Patel on 11/15/18.
//  Copyright © 2018 Arzoo Patel. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func resetAccount(_ sender: Any) {
            let defaults = UserDefaults.standard
            let redID = defaults.value(forKey: "redID")
            let password = defaults.value(forKey: "password")
            
            let parameters: Parameters = ["redid": redID!,"password":password!]
            Alamofire.request("https://bismarck.sdsu.edu/registration/resetstudent",method: .get, parameters: parameters).responseJSON { response in
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
    @IBAction func backToInitial(unwindSegue:UIStoryboardSegue){
        
    }
}

