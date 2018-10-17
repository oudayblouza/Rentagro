//
//  ViewController.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 07/11/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON
import Alamofire_SwiftyJSON
import RAMAnimatedTabBarController
import CDAlertView
import SwiftSpinner

class ViewController: UIViewController,UITextFieldDelegate {
    
    @objc let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    var user = Users ()
    let preferences = UserDefaults.standard
    
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        
        self.username.delegate = self
        self.password.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (UserDefaults.standard.isLoggedIn()){
            self.performSegue(withIdentifier: "fromLoginToGuestMain", sender: (Any).self)
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //btn login Action : login to the app
    @IBAction func btnLogin(_ sender: Any) {
        SwiftSpinner.show("Authentification")
        if(isValidEmail(testStr: username.text!)){
            Alamofire.request(URLS.GETURL+"login.php?username="+username.text!).responseString{
                response in
                
                if response.value != "not found" {
                    print(response.value)
                    if(response.value == self.password.text){
                        
                        self.getUser(email: self.username.text!)
                        
                    }else{
                        SwiftSpinner.hide()
                        CDAlertView(title: "Alert", message: "Wrong Password ", type: .error).show()
                    }
                }else{
                    SwiftSpinner.hide()
                    
                    CDAlertView(title: "Alert", message: "Wrong Email ", type: .error).show()
                    
                }
            }
        }else{
            SwiftSpinner.hide()
            
            CDAlertView(title: "Alert", message: "Insert valid Email ", type: .error).show()
        }
        
    }
    
    //fuction to hide keybord
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        username.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }
    
    // Alert Func
    @objc func displayMyAlert(mymessage:String,mytitle:String,mybutton:String)  {
        let alert = UIAlertController(title: mytitle, message: mymessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(mybutton, comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // verify if valid email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    //get the user Object
    @objc func getUser(email:String){
        
        print(URLS.GETURL+"User/user_by_email.php?email="+email)
        Alamofire.request(URLS.GETURL+"User/user_by_email.php?email="+email).responseJSON(completionHandler: {
            response in
            
            switch response.result {
                
            case .success(let value):
                
                let json = JSON(value)
                let data = json["users"].dictionaryObject
                SwiftSpinner.hide()
                print("houna achi5a ")
                
                
                
                let x = Int(data!["id"] as!  String)
                
                
                UserDefaults.standard.setUserName(value: ((data!["username"] as? String) ?? "untitled"))
                UserDefaults.standard.setId(value: ((data!["id"] as? String) ?? "untitled"))
                UserDefaults.standard.setEmail(value: ((data!["email"] as? String) ?? "untitled"))
                UserDefaults.standard.setTel(value: ((data!["numtel"] as? String) ?? "untitled"))
                UserDefaults.standard.setIsLogedIn(value: true)
                
                
                self.performSegue(withIdentifier: "fromLoginToGuestMain", sender: (Any).self)
                
            case .failure(let error):
                SwiftSpinner.hide()
                self.performSegue(withIdentifier: "fromLoginToGuestMain", sender: (Any).self)
                return
            }
        })
    }
}




