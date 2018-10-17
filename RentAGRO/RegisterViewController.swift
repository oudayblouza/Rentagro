//
//  RegisterViewController.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 08/11/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import UIKit
import Alamofire
import CDAlertView
import SwiftSpinner

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    


    @IBOutlet weak var myImageProfile: UIImageView!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var lblname: UITextField!
    @IBOutlet weak var lbllastname: UITextField!
    @IBOutlet weak var lblemail: UITextField!
    @IBOutlet weak var creationcompte: UIButton!
    @IBOutlet weak var lblpassword: UITextField!
    @IBOutlet weak var lblrepeatpassword: UITextField!
    @IBOutlet weak var lblusername: UITextField!
    @IBOutlet weak var myImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Addin g action to image view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addPhoto(tapGestureRecognizer:)))
        myImageProfile.isUserInteractionEnabled = true
        myImageProfile.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//func to verify valid data on UI
    @IBAction func actioncreation(_ sender: Any) {
        let username = lblusername.text
        let userpassword = lblpassword.text
        let userrepeatpassword = lblrepeatpassword.text
        let email = lblemail.text
        let numTel = lbllastname.text
        let name = lblname.text
        
        //tester les champs 
        
        if ((username?.isEmpty)!||(userpassword?.isEmpty)!||(userrepeatpassword?.isEmpty)! )
        {
            CDAlertView(title: "Alert", message: "All fields are required", type: .warning).show()
            return
        }
        
        if(!isValidEmail(testStr:email!)){

             CDAlertView(title: "Alert", message: "Please insert a valid Email", type: .warning).show()
            return
        }
        if(numTel?.length != 8){
             CDAlertView(title: "Alert", message: "Please insert a valid Tel number", type: .warning).show()
            return
        }
        if (userpassword != userrepeatpassword)
        {
            CDAlertView(title: "Alert", message: "Passwords do not match", type: .warning).show()
            return
        }
            SwiftSpinner.show("In Progress ...")
        VerifUsername(username: username!, password: userpassword!, email: email!, name: name!, numTel: numTel!)
        
    }
    
    @IBAction func dissmiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.scrollview.endEditing(true)
        
    }
    
   
    // func to add user in database
    @objc func addUserToDatabase(username:String,password:String,email:String,name:String,numTel:String) {
        let rate = 0
        let voters = 0
        let roles = "Amateur"
        
        let paramters: Parameters=[
                "username":username,
                "email":email,
                "password":password,
                "prenom":name,
                "numtel":numTel,
                "rate":rate,
                "voters":voters,
                "delegation_id":1,
                "latitude":0,
                "longitude":0,
                "roles":roles
        ]

        Alamofire.request(URLS.GETURL+"User/ajouterUser.php", parameters: paramters).responseString{
            response in
           print(response.description)
            if response.value! == "success" {
                
                    SwiftSpinner.hide()
                    CDAlertView(title: "Success", message: "Registration with success", type: .success).show()
                    print(response.result.description)
            }else{
                    SwiftSpinner.hide()
                    CDAlertView(title: "Alert", message: "Error Registration", type: .error).show()
                    print(response.result.description)
        }
        }
        
        
    }
    
    
    
    //func to verify if username exist
    @objc func VerifUsername(username:String,password:String,email:String,name:String,numTel:String){
        let paramters: Parameters=[
            "username":username
        ]
        Alamofire.request(URLS.GETURL+"User/find_by_Username.php", parameters: paramters).responseString{
            response in
            
            if response.value == "success" {
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Username Aleready Exist", type: .warning).show()
            }else{
                self.VerifEmail(username: username, password: password, email: email, name: name, numTel: numTel)

            }
        }
    }
    
    //func to verify if email exist

    @objc func VerifEmail(username:String,password:String,email:String,name:String,numTel:String){
        let paramters: Parameters=[
            "email":email
        ]
        Alamofire.request(URLS.GETURL+"User/find_by_Email.php", parameters: paramters).responseString{
            response in
            
            if response.value == "success" {
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Email Aleready Exist", type: .warning).show()
            }else{
                self.myImageUploadRequest(myImage: self.myImageProfile.image!, username: username, password: password, email: email, name: name, numTel: numTel)
                

            }
        }
    }
    
    // func to hide keybord
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTage=textField.tag+1;

        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    //func to verify if valid email

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    

    
    //Select Photo source func (camera or library)
    
    @objc func addPhoto(tapGestureRecognizer: UITapGestureRecognizer) {
        print("sssss")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source",preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "camera", style: .default, handler: {(action:UIAlertAction)in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo library", style: .default, handler: {(action:UIAlertAction)in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.myImageProfile.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //uploading photo to server
    @objc func myImageUploadRequest(myImage: UIImage,username:String, password: String, email: String, name: String, numTel: String) {
        
        let myUrl = NSURL(string: URLS.GETURL+"uploadImageProfilios.php")
        
        let request = NSMutableURLRequest(url:myUrl! as URL)
        request.httpMethod = "POST"
        
        let param = [
            "firstName"  : "Sergey",
            "lastName"    : "seddik",
            "userId"    : username
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(myImage, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary, name: username) as Data
        
        
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                print("notsexonthebitch")
                print(json ?? "")
                self.addUserToDatabase(username: username, password: password, email: email, name: name, numTel: numTel)
                
                
            }catch
            {
                print("sexonthebitch")
                print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    //define image storage parameters
    @objc func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String,name: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let mimetype = "image/jpeg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(name+".jpeg")\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    @objc func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    

}
