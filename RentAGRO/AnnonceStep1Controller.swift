//
//  AnnonceStep1Controller.swift
//  RentAgro
//
//  Created by Ouday Blouza on 17/11/2017.
//  Copyright © 2017 Ouday Blouza. All rights reserved.
//

import UIKit
import Alamofire
import CDAlertView
import SwiftSpinner

class AnnonceStep1Controller: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @objc var vill = String()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 10)
        {
            return myArray.count
        }
        else{
            return myArray1.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(pickerView.tag == 10)
        {
            return myArray[row]
        }
        else{
            return myArray1[row]
        }
    }
    
    
    
    
    
    @objc var myArray1 = [String]()
    @objc var myArray = [String]()
    
    @IBOutlet weak var pickCategory: UIPickerView!
    @IBOutlet weak var pickVille: UIPickerView!
    
    
    
    @IBOutlet weak var panel1: UIVisualEffectView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var blurbtn: UIVisualEffectView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading")
        fillPick();
        fillPickCateg();
        
        self.panel1.layer.cornerRadius = self.panel1.frame.size.width / 16;
        self.panel1.clipsToBounds = true
        self.panel1.layer.borderWidth = 0.5;
        panel1.layer.borderColor = UIColor.white.cgColor
        
        self.btnNext.layer.cornerRadius = self.btnNext.frame.size.width / 16;
        self.btnNext.clipsToBounds = true
        
        
        self.blurbtn.layer.cornerRadius = self.blurbtn.frame.size.width / 16;
        self.blurbtn.clipsToBounds = true
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // fill the ville picker with database data
    @objc func fillPick(){
        
        Alamofire.request(URLS.GETURL+"ville/select.php",method:.get).responseJSON{response in
            if (response.result.isSuccess){
                if let JSON = response.result.value{
                    let jsonResult:Dictionary = JSON as! Dictionary<String,Any>
                    print(jsonResult["ville"])
                    
                    if let villes = jsonResult["ville"] as? [[String:String]] {
                        for ville in villes {
                            let nomvl = ville["nom"]!
                            self.myArray1.append(nomvl)
                            // get other values
                            print(nomvl)
                        }
                    }
                    
                    self.nomville =  self.myArray1[0]
                    self.pickVille.reloadAllComponents()
                    
                    
                    CDAlertView(title: "Add advert", message: "Choose your advert Category and your Town and press OK", type: .notification).show()
                }
            }else if (response.result.isFailure){
                print(response.result.error)
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error Loading", type: .error).show()
                
            }
        }
    }
    
    
    // fill the categorie picker with database data

    @objc func fillPickCateg(){
        
        Alamofire.request(URLS.GETURL+"categorie/select.php",method:.get).responseJSON{response in
            if (response.result.isSuccess){
                if let JSON = response.result.value{
                    let jsonResult:Dictionary = JSON as! Dictionary<String,Any>
                    print(jsonResult["categorie"])
                    
                    if let categories = jsonResult["categorie"] as? [[String:String]] {
                        for categorie in categories {
                            let nomcateg = categorie["nom"]!
                            self.myArray.append(nomcateg)
                            
                        }
                    }
                    
                    self.nomcategorie =  self.myArray[0]
                    self.pickCategory.reloadAllComponents()
                    SwiftSpinner.hide()
                }
            }else if (response.result.isFailure){
                print(response.result.error)
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error Loading", type: .error).show()
            }
        }
    }
    
    
    @objc var nomville:String = ""
    @objc var nomcategorie:String = ""
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView.tag == 20)
        {
            self.nomville =  myArray1[row]
            
        }
        if(pickerView.tag == 10)
        {
            self.nomcategorie =  myArray[row]
            
        }
        
    }
    

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (nomville == "" && nomcategorie == "")  {
             CDAlertView(title: "Alert", message: "Error Retry Later", type: .error).show()
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
            if (segue.identifier == "SegueStep1"){
                let receiver = (segue.destination as! AnnonceStep2Controller)
                receiver.ville1 = nomville
                receiver.categorie1=nomcategorie
                
            }
  
    }
    
    
    
    @IBAction func Next(_ sender: Any) {
        
    }
    
    
    
    
}
