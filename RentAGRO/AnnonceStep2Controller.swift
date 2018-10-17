//
//  AnnonceStep2Controller.swift
//  RentAgro
//
//  Created by Ouday Blouza on 17/11/2017.
//  Copyright © 2017 Ouday Blouza. All rights reserved.
//

import UIKit
import CDAlertView
import SwiftSpinner
class AnnonceStep2Controller: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      
        if(pickerView.tag == 20)
        {
           return myArray1.count
        }else
        {
        return myArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if(pickerView.tag == 20)
        {
           return myArray1[row]
        }else
        {
            return myArray[row]
        }
    }
    
    @objc var nomdel:String = ""
      @objc var nomcateg:String = ""
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 20)
        {
            nomdel =  myArray1[row]
         //   print(nomdel)
        }
        if(pickerView.tag == 10)
        {
            nomcateg =  myArray[row]
            //   print(nomdel)
        }
    }
    
      @objc var myArray1 = [String]()
     @objc var myArray = [String]()
    @IBOutlet weak var pickerdel: UIPickerView!
    
    @IBOutlet weak var pickercateg: UIPickerView!
    @IBOutlet weak var panel1: UIVisualEffectView!
    @IBOutlet weak var btnNext: UIButton!
    
    @objc var ville1 = String()
    var ville2 = Ville()
    @objc var categorie1 = String()
    var categorie2 = Categories()
    @IBOutlet weak var blurbtn: UIVisualEffectView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panel1.layer.cornerRadius = self.panel1.frame.size.width / 16;
        self.panel1.clipsToBounds = true
        self.panel1.layer.borderWidth = 0.5;
        panel1.layer.borderColor = UIColor.white.cgColor
        
        self.btnNext.layer.cornerRadius = self.btnNext.frame.size.width / 16;
        self.btnNext.clipsToBounds = true
       
        self.blurbtn.layer.cornerRadius = self.blurbtn.frame.size.width / 16;
        self.blurbtn.clipsToBounds = true
        SwiftSpinner.show("Loading")
        loadville()
        loadCateg()

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
    
    //fill the picker with delegation throw the delegation service
    @objc func fillPick(){
  
     DelegationService.getByVille(vil: ville2, completion: { (error: Error?, delegations:[Delegation]? ) in
 
        if let delegations = delegations {
            self.myArray1 = delegations.map({ (delegation: Delegation) -> String in
            delegation.nom!
            })
             self.nomdel =  self.myArray1[0]
            self.pickerdel.reloadAllComponents()
        }
        if let error = error {
            print(error)
            SwiftSpinner.hide()
            CDAlertView(title: "Alert", message: "Error Loading", type: .error).show()
        }
        
    })
        
        
    }
    //fill the picker with Service throw the typeservice

    @objc func fillPickType(){
        
        TypeService.getByCategorie(categ: categorie2, completion: { (error: Error?, types:[Type]? ) in
            
            if let types = types {
                self.myArray = types.map({ (type: Type) -> String in
                    type.nom!
                })
                self.nomcateg =  self.myArray[0]
                self.pickercateg.reloadAllComponents()
                SwiftSpinner.hide()
            }
            if let error = error {
                print(error)
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error Loading", type: .error).show()
            }
            
        })
        
        
    }
    //get the ville name from database throw VilleService
    @objc func loadville(){
       
        VilleService.getByNom(vilnom: ville1.replacingOccurrences(of: " ", with: "%20"), completion: { (error: Error?, ville:Ville?) in
            if let ville = ville {
                self.ville2 = ville
                self.fillPick()
            }else{
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error Loading", type: .error).show()
            }
            
        })
    }
    //get the categorie name from database throw categorieService

    @objc func loadCateg(){
        
        CategorieService.getByNom(categnom : categorie1.replacingOccurrences(of: " ", with: "%20"), completion: { (error: Error?, categorie:Categories?) in
            if let categorie = categorie {
                self.categorie2 = categorie
                print("zebzebzeb")
                self.fillPickType()
            }else{
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error Loading", type: .error).show()
            }
            
        })
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (self.nomdel == "" && self.nomcateg == "")  {
            CDAlertView(title: "Alert", message: "Error Retry Later", type: .error).show()
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if (segue.identifier == "SegueStep2"){
            let receiver = (segue.destination as! AddAdverController)
           receiver.delegationname = self.nomdel
              receiver.typename = self.nomcateg
            
        }
    }
    
}
