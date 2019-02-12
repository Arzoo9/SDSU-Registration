//
//  RegisterStudentViewController.swift
//  Assignment 5
//
//  Created by Arzoo Patel on 11/16/18.
//  Copyright © 2018 Arzoo Patel. All rights reserved.
//

import UIKit
import Alamofire

class RegisterStudentViewController: UIViewController {

   
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var redIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func registerStudent(_ sender: Any) {
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let redID = redIdTextField.text!
        let password = passwordTextField.text!
        let emailID = emailTextField.text!
        let parameters: Parameters = [
            "firstname": firstName, "lastname" : lastName, "redid" : redID, "password" : password, "email" : emailID ]
        Alamofire.request("https://bismarck.sdsu.edu/registration/addstudent", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{ response in
            if let json = response.result.value {
                let result = json as! Dictionary<String,String>
                if let value  = result["error"] {
                    let alert = UIAlertView.init(
                        title: "",
                        message: value,
                        delegate: self,
                        cancelButtonTitle: "Cancel")
                    alert.show()
                }else {
                    let alert = UIAlertView.init(
                        title: "",
                        message: "You are successfully registred",
                        delegate: self,
                        cancelButtonTitle: "Cancel")
                    alert.show()
                    let defaults = UserDefaults.standard
                    defaults.set(firstName, forKey: "firstName")
                    defaults.set(lastName, forKey: "lastName")
                    defaults.set(redID, forKey: "redID")
                    defaults.set(password, forKey: "password")
                    defaults.set(emailID, forKey: "emailID")
                    self.performSegue(withIdentifier: "toDashboard", sender: "self")
                }
            }
        }
        
    }
    @IBAction func goToDashboard(_ sender: Any) {
        
        if UserDefaults.standard.string(forKey: "firstName") != nil, UserDefaults.standard.string(forKey: "password") != nil,
            UserDefaults.standard.string(forKey: "redID") != nil{
             performSegue(withIdentifier: "toDashboard", sender: self)
        }else{
            let alert = UIAlertView.init(
                title: "",
                message: "No student found in phone, please register",
                delegate: self,
                cancelButtonTitle: "Cancel")
            alert.show()
        }
       
    }
    
    @IBAction func backToRegisterStudent(unwindSegue:UIStoryboardSegue){
        
    }
}
