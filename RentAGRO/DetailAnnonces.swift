//
//  DetailAnnonces.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 22/11/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import UIKit
import Floaty
import DTImageScrollView
import SwiftSpinner
import RZTransitions
import CDAlertView
class DetailAnnonces: UIViewController,DTImageScrollViewDatasource {
    @objc func imageURL(index: Int) -> URL {
        //self.imgscroll.layer.cornerRadius = 10
        //self.imgscroll.placeholderImage = #imageLiteral(resourceName: "default-placeholder-300x300")
        
        return URL(string: URLS.GETURL+"upload/\(annonces.imagesDir!)/\(index).jpeg")!
        
    }
    
    @objc func numberOfImages() -> Int {
        return annonces.nbrimages!
    }
    
    @IBOutlet weak var ScrollV: UIScrollView!
    
    @IBOutlet weak var lblTitre: UILabel!
    
    @IBOutlet weak var lblDelegation: UILabel!
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblNature: UILabel!
    
    @IBOutlet weak var imgscroll: DTImageScrollView!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var lblPrix: UILabel!
    @IBOutlet weak var lblDateDebut: UILabel!
    @IBOutlet weak var lblNumTel: UILabel!
    var annonces = Annonces()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Transition lezyana
        //let navigationController = UINavigationController()
        navigationController?.delegate = RZTransitionsManager.shared()
        RZTransitionsManager.shared().defaultPresentDismissAnimationController = RZZoomBlurAnimationController()
        RZTransitionsManager.shared().defaultPushPopAnimationController = RZRectZoomAnimationController()
        
        
        
        
        self.imgscroll.datasource = self
        
        self.lblTitre.text = annonces.titre!
     
        loadDel(id: (annonces.delegation?.id!)!)
        loadCateg(id : (annonces.type?.id!)!)
        self.lblNature!.text = "Advert nature : "+annonces.nature!
        print(annonces.nbrimages!)
        self.lblDescription!.text = annonces.description
        self.lblPrix!.text = "Price : \(annonces.prix ?? 0)"+" "+annonces.renttype!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd "
        
        self.lblDateDebut!.text = "renting Date :"+formatter.string(from: annonces.dateDebut!)
        self.lblNumTel!.text = "Duration : \(annonces.duree ?? 0)"
        
        
        
        //floating button
        let floaty = Floaty()
        floaty.openAnimationType = .slideLeft
    
        floaty.addItem("Call me on \(self.annonces.numTel ?? 0)", icon: #imageLiteral(resourceName: "call-answer-3"), handler: { item in
            let url: NSURL = URL(string: "TEL://\(self.annonces.numTel ?? 0)")! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            floaty.close()
        })
        floaty.addItem("Show location in map ?", icon: #imageLiteral(resourceName: "placeholder-2"), handler: { item in
            
            self.transitioningDelegate = RZTransitionsManager.shared()
            
            self.performSegue(withIdentifier: "MapSegue", sender: nil)
            //self.present(nextViewController, animated:true) {}
            //
            //let segue = UIStoryboardSegue.self
            //let yourNextViewController = (segue.destination as! DetailAnnonces)
            //yourNextViewController.transitioningDelegate = RZTransitionsManager.shared()
            
            
            floaty.close()
        })
        
        
        
        
    
        ScrollV.addSubview(floaty)
      //  self.view.addSubview(floaty)
        
        
        //Design
        self.imgscroll.placeholderImage = #imageLiteral(resourceName: "default-placeholder-300x300")
        self.imgscroll.show()
      //  self.imgscroll.layer.cornerRadius = 10
        
        self.lblDescription.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
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

    //viber call function
    @IBAction func AppelViber(_ sender: Any) {
        
        let url: NSURL = URL(string: "viber://\(annonces.numTel ?? 0)")! as NSURL
        
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    //phone call function

    @IBAction func AppelTelephonique(_ sender: Any) {
       
        let url: NSURL = URL(string: "TEL://\(annonces.numTel ?? 0)")! as NSURL
        
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "MapSegue"){
            let controller = segue.destination as! MapAfterDetailViewController
            controller.annonces = annonces
            
        }
    }
    //get data from TypeService

    @objc func loadCateg(id : Int){
        
        TypeService.getById(id: id, completion: { (error: Error?, type:Type?)  in
            if let type = type {
                self.lblType!.text = "Advert Type : "+type.nom!
            }else{
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error Loading type", type: .error).show()
            }
        })
        
    
    }
    //get data from DelegationService
    @objc func loadDel(id : Int){
        
        DelegationService.getById(id: id, completion: { (error: Error?, delegation:Delegation?)  in
            if let delegation = delegation {
                self.lblDelegation!.text = "Advert Department : "+delegation.nom!
            }else{
                SwiftSpinner.hide()
                CDAlertView(title: "Alert", message: "Error Loading Department", type: .error).show()
            }
        })
        
        
    }
}
