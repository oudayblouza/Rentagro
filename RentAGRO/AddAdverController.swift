//
//  AddAdverController.swift
//  RentAgro
//
//  Created by Ouday Blouza on 17/11/2017.
//  Copyright © 2017 Ouday Blouza. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Photos
import Fusuma
import CDAlertView
import SwiftSpinner
import GoogleMaps
import GooglePlaces

class AddAdverController: UIViewController,UITextFieldDelegate,FusumaDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CLLocationManagerDelegate {
    @objc var selectedDuration = ""
    @objc let duration = ["Per Hour","Per Day","Per Mounth","Per Year"]
    let preferences = UserDefaults.standard
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return duration.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return duration[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDuration = self.duration[row]
        renttype = self.duration[row]
        print(selectedDuration)
    }
    
    
    
    var user = Users()
    
    
    @IBAction func textFieldPrimaryAction(_ sender: Any) {
        
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var panelelem: UIView!
    @IBOutlet weak var descriptxt: UITextView!
    @IBOutlet weak var panel1: UIView!
    @objc var images = [UIImage]()
    @objc var delegationname = String()
    @objc var typename = String()
    @objc var delegationId = String()
    @objc var typeId = String()
    
    @IBOutlet weak var titretxt: UITextField!
    @IBOutlet weak var prixtxt: UITextField!
    @IBOutlet weak var datepickertxt: UIDatePicker!
    @IBOutlet weak var dureetxt: UITextField!
    @IBOutlet weak var numteltxt: UITextField!
    @IBOutlet weak var naturepick: UISegmentedControl!
    var delegation1 = Delegation()
    var type1 = Type()
    var renttype = String()
    //verif the validity of data in UI
    func  verif()->Bool{
        var verif = false
        if ((titretxt.text!.isEmpty)||(descriptxt.text!.isEmpty)||(prixtxt.text!.isEmpty)||(dureetxt.text!.isEmpty)||(numteltxt.text!.isEmpty) )
        {
            CDAlertView(title: "Alert", message: "All fields are required", type: .warning).show()
            return verif
        }
        
        if(!isStringAnInt(string: (numteltxt.text)!)){
            CDAlertView(title: "Alert", message: "Please insert a valid Tel number", type: .warning).show()
            return verif
        }
        
        if(!isStringAnInt(string: (dureetxt.text)!)){
            CDAlertView(title: "Alert", message: "Please insert a valid Duration", type: .warning).show()
            return verif
        }
        if(!isStringAnInt(string: prixtxt.text!)){
            CDAlertView(title: "Alert", message: "Please insert a valid Price", type: .warning).show()
            return verif
        }
        if(numteltxt.text?.length != 8){
            CDAlertView(title: "Alert", message: "Please insert a valid Tel number", type: .warning).show()
            return verif
        }
        verif = true
        return verif
    }
    
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
   //fill the annonce object with data from the UI
    @IBAction func AddAdvert(_ sender: Any) {
        if self.images.isEmpty
        {
            CDAlertView(title: "Alert", message: "Please insert a Images", type: .warning).show()
        }
        else
        {
            if(verif()){
                
                let annonce1 = Annonces()
                
                annonce1.titre=titretxt.text
                annonce1.nature=naturepick.titleForSegment(at: naturepick.selectedSegmentIndex)
                annonce1.renttype = renttype
                annonce1.description = descriptxt.text
                annonce1.prix = Int(prixtxt.text!)
                
                //Date time now
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMddHHmmss"
                let date1 =   formatter.string(from: date)
                
                annonce1.dateDebut = datepickertxt.date
                annonce1.duree=Int(dureetxt.text!)
                annonce1.numTel=Int(numteltxt.text!)
                
                //getting current user
                annonce1.user=self.user
                let typess = Type()
                typess.id=Int(typeId)
                annonce1.type=type1
                annonce1.delegation=delegation1;
                annonce1.validite=1;
                print(String(describing: annonce1.delegation?.id)+String(describing: annonce1.user?.id)+String(describing: annonce1.type?.id))
                //Ajout photos
                var count: Int = 0
                let usernameCurrent = UserDefaults.standard.getUserName()+date1
 
                annonce1.imagesDir=usernameCurrent
                
                annonce1.nbrimages = self.images.count
                
                SwiftSpinner.show("Uploading ...")
                for image in self.images
                {
                    self.myImageUploadRequest(myImage: image, path : annonce1.imagesDir!, count: count ,annonce1: annonce1)
                    count += 1
                }
                
                
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            CDAlertView(title: "", message: "Location services are not enabled", type: .error).show()
            print("Location services are not enabled");
        }
        
        self.user.username = UserDefaults.standard.getUserName()
        self.user.id = Int(UserDefaults.standard.getId())
        
        renttype = self.duration[0]
        self.panel1.layer.cornerRadius = self.descriptxt.frame.size.width / 16;
        self.panel1.clipsToBounds = true;
        
        self.panel1.layer.borderWidth = 0.25;
        panel1.layer.borderColor = UIColor.gray.cgColor
        
        self.descriptxt.layer.cornerRadius = self.descriptxt.frame.size.width / 16;
        self.descriptxt.clipsToBounds = true;
        
        self.titretxt.delegate = self
        self.prixtxt.delegate = self
        self.dureetxt.delegate = self
        self.numteltxt.delegate = self
        print(delegationname)
        SwiftSpinner.show("Loading Data")
        //get delegation from DelegationService
        DelegationService.getByNom(delnom: delegationname.replacingOccurrences(of: " ", with: "%20"), completion: { (error: Error?, delegation:Delegation?) in
            if let delegation = delegation {
                
                self.delegation1 = delegation
            }else{
                print("erreur connection")
            }
        })
        //get service from TypeService

        TypeService.getByNom(typenom: typename.replacingOccurrences(of: " ", with: "%20")
            , completion: { (error: Error?, type:Type?) in
                if let type = type {
                    self.type1 = type
                    SwiftSpinner.hide()
                }else{
                    print("erreur connection type")
                }
                
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titretxt.resignFirstResponder()
        
        
        return true
    }
    
     //add advert to database function
    func addAnnonce(annonce:Annonces) {
        
        let paramters: Parameters=[
            "titre":annonce.titre! ,
            "description":annonce.description!,
            "prix":annonce.prix!,
            "validite":1,
            "dateDebut":annonce.dateDebut!,
            "duree":annonce.duree!,
            "numTel":annonce.numTel!,
            "user_id":(annonce.user?.id)!,
            "type_id":(annonce.type?.id)!,
            "delegation_id":(annonce.delegation?.id)!,
            "nature":annonce.nature!,
            "etat":1,
            "renttype":annonce.renttype!,
            "path":annonce.imagesDir!,
            "nbrImg":annonce.nbrimages!,
            "longitude":longitude,
            "latitude":latitude
        ]
        
        print(paramters)
        
        Alamofire.request(URLS.GETURL+"annonces/ajouterAnnonce.php", parameters: paramters).responseString{
            
            response in
            print(response)
            if response.value == "success" {
                
                
                SwiftSpinner.hide()
                CDAlertView(title: "Success", message: "Uploding Advert With Success", type: .success).show()
                //ici notification
                print(response.result.description)
                
                
                
            }
            else {
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error Adding Advert", type: .error).show()
                print(response.result.description)
            }
            
            
        }
        
        
        
    }
    //fill the fusuma image viwer
    @objc func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Number of selection images: \(images.count)")
        
        var count: Double = 0
        self.images = images
        for image in images {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
                
                self.imageView.image = image
                print("w: \(image.size.width) - h: \(image.size.height)")
            }
            count += 1
        }
        
        
    }
    
    
    
    @IBAction func showButtonPressedd(_ sender: Any) {
        let fusuma = FusumaViewController()
        
        fusuma.delegate = self
        fusuma.cropHeightRatio = 1.0
        fusuma.allowMultipleSelection = true
        //        fusuma.availableModes = [.video]
        fusumaSavesImage = true
        
        self.present(fusuma, animated: true, completion: nil)
    }
    // Return the image which is selected from camera roll or is taken via the camera.
    @objc func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Image captured from Camera")
            
        case .library:
            
            print("Image selected from Camera Roll")
            
        default:
            
            print("Image selected")
        }
        
        imageView.image = image
    }
    // Return the image but called after is dismissed.
    @objc func fusumaDismissedWithImage(image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Called just after dismissed FusumaViewController using Camera")
            
        case .library:
            
            print("Called just after dismissed FusumaViewController using Camera Roll")
            
        default:
            
            print("Called just after dismissed FusumaViewController")
        }
    }
    @objc func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("video completed and output to file: \(fileURL)")
        print("file output to: \(fileURL.absoluteString)")
    }
    
    // When camera roll is not authorized, this method is called.
    @objc func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        
        guard let vc = UIApplication.shared.delegate?.window??.rootViewController,
            let presented = vc.presentedViewController else {
                
                return
        }
        
        presented.present(alert, animated: true, completion: nil)
    }
    
    @objc func fusumaClosed() {
        
        print("Called when the FusumaViewController disappeared")
    }
    
    @objc func fusumaWillClosed() {
        
        print("Called when the close button is pressed")
    }
    //set the fusuma parameters
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
    }
    
    
    // upload image to serer function
    
     func myImageUploadRequest(myImage: UIImage,path: String,count: Int,annonce1: Annonces) {
        
        let myUrl = NSURL(string: URLS.GETURL+"uploadImage.php")
        
        let request = NSMutableURLRequest(url:myUrl! as URL)
        request.httpMethod = "POST"
        
        let param = [
            "firstName"  : "Sergey",
            "lastName"    : "annoncedate",
            "userId"    : path
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(myImage, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary,count: count) as Data
        
        
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error uploading", type: .error).show()
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
                if(count+1 == self.images.count){
                       self.addAnnonce(annonce:annonce1)
                    let urlNotif = URLS.GETURL+"/Notif.php?title="+self.user.username!+" Added A New Advert on RentAGRO&body=Title: "+annonce1.titre!
                    let url = urlNotif.replacingOccurrences(of: " ", with: "%20")
                    Alamofire.request(url).responseString{
                        response in
                        print(response)
                    }
                }
                
                
            }catch
            {
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error uploading", type: .error).show()
                
                print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    // set saving image parameters
    @objc func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String,count: Int) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "\(count).jpeg"
        
        let mimetype = "image/jpeg"
        
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
    
    
    
    // getting full adress based on latitude and longitude
    @IBAction func locAdd(_ sender: Any) {
        var texte = String()
        SwiftSpinner.show("Loading location")
        let longitude: CLLocationDegrees = Double(self.longitude)
        let latitude: CLLocationDegrees = Double(self.latitude)
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            //        // Place details
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            let locationName = placeMark?.locality ?? "Could not find city"
            texte = locationName
            
            
            // Country
            guard let country = placeMark?.addressDictionary?["Country"] as? String else {
                texte = "could not find country"
                return
            }
            print(country, terminator: "")
            print("seddik ouaz "+texte)
            texte = texte+", "+country
            print(texte)
            SwiftSpinner.hide()
            CDAlertView(title: "Your adress is : ", message: texte, type: .success).show()
        })
        
        
    }
    
    // get the latitude and longitude
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.longitude = locValue.longitude
        self.latitude = locValue.latitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        // show alert
        CDAlertView(title: "Connection failed", message: "No internet connection", type: .error).show()
    }
    var longitude = Double()
    var latitude = Double()
    let locationManager = CLLocationManager()
}







extension NSMutableData {
    
    @objc func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
    
}
