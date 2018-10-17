//
//  ProfileController.swift
//  RentAgro
//
//  Created by Ouday Blouza on 14/11/2017.
//  Copyright © 2017 Ouday Blouza. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftSpinner

class ProfileController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

   // @IBOutlet weak var headview: UIView!
  //@IBOutlet weak var btnedit: UIButton!
    
    @IBOutlet weak var lblemail: UITextField!
    @IBOutlet weak var lbllastName: UITextField!
    @IBOutlet weak var lblusername: UITextField!
    @IBOutlet weak var LblName: UILabel!
    @IBOutlet weak var LblPhone: UITextField!
    
    @IBOutlet weak var Userlabel: UILabel!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var btnedit: UIButton!
    var user = Users()
    @objc var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.lblusername.isEnabled = false
        self.lblemail.isEnabled = false
        self.lbllastName.isEnabled = false
         self.LblPhone.isEnabled = false
        
        
        self.username = UserDefaults.standard.getUserName()
         DispatchQueue.global().async {
        self.handleCurrentUser()

        }
        
        btnedit.layer.cornerRadius = 10; // this value varyas per your desire
        btnedit.clipsToBounds = true;
 
        self.img2.layer.cornerRadius = self.img2.frame.size.width / 2;
        self.img2.clipsToBounds = true;

        
        
        self.img2.layer.borderWidth = 3.0;
        img2.layer.borderColor = UIColor.white.cgColor
        

    }
    // action on logout Button : logout
    @IBAction func logout(_ sender: Any) {
        
        
        UserDefaults.standard.setUserName(value: "")
        UserDefaults.standard.setId(value: "")
        UserDefaults.standard.setEmail(value: "")
        UserDefaults.standard.setTel(value: "")
        UserDefaults.standard.setIsLogedIn(value: false)
        
        self.dismiss(animated: true) {
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.show("Loading data from server...")
        let url = URLS.GETURL+"images/premium/"+self.username+"/"+self.username+".jpeg"
        print(url)
        if let imageURL = URL(string: url.replacingOccurrences(of: " ", with: "%20")), let placeholder = UIImage(named: "default-placeholder-300x300") {
            img2.af_setImage(withURL: imageURL, placeholderImage: placeholder)
        }
        SwiftSpinner.hide()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// function to fill the profile view
    @objc func handleCurrentUser() {
        
       
        ProfileServices.getCurrentUser(username: self.username) { (success,error, response) in
            if success{
                guard let userdb = response  else{
                    return
                }
                
                self.user=userdb
                self.user.id = userdb.id
                self.Userlabel.text = self.username
                self.lblemail.text = self.user.email
                self.lbllastName.text = self.user.nom!+" "+self.user.prenom!
                self.lblusername.text = self.user.username
                self.LblPhone.text = String(describing: self.user.numtel!)
            }
            else{
                print("haha")
                print(error ?? "")
            }
        }
        
       
        
    }
    

    // func to choose beetween Camera and library
    @IBAction func updatePhoto(_ sender: Any) {
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
    
    // func to download images from the server and fill the image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.myImageUploadRequest(myImage: image)
        SwiftSpinner.show("Loading profile image ...")
        
        Alamofire.request(URLS.GETURL+"rentagro/Imagesprojet/"+self.username+".png").responseImage { response in
            debugPrint(response)
            print(response.request ?? "")
            print(response.response ?? "")
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                image.af_inflate()
                
                self.img2.image = image
                SwiftSpinner.hide()
            }
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //upload image on server function
        @objc func myImageUploadRequest(myImage: UIImage) {
        
        let myUrl = NSURL(string: URLS.GETURL+"rentagro/uploadImageProfil.php")
        
        let request = NSMutableURLRequest(url:myUrl! as URL)
        request.httpMethod = "POST"
        
        let param = [
            "firstName"  : "Sergey",
            "lastName"    : "seddik",
            "userId"    : "seddik"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(myImage, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        
        
        
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
                
                
                
            }catch
            {
                print("sexonthebitch")
                print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    // func to set image parameters
    @objc func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = UserDefaults.standard.getUserName()+".png"
        
        let mimetype = "image/png"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    @objc func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    //set UI state
    @IBAction func edit(_ sender: Any) {
        
        if( self.lblusername.isEnabled == true)
        {
            self.lblusername.isEnabled = false
            self.lbllastName.isEnabled = false
            self.lblemail.isEnabled = false
            
        }
        
        if( self.lblusername.isEnabled == false)
        {
            self.lblusername.isEnabled = true
            self.lbllastName.isEnabled = true
            self.lblemail.isEnabled = true
            
        }
        
    }
    
}
