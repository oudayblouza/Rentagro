//
//  MyAdvertsViewController.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 04/12/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import UIKit
import Alamofire
import RZTransitions
import AlamofireImage
import RainyRefreshControl
import SwiftyJSON
import Spring
import CDAlertView
import SwiftSpinner



class MyAdvertsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var annonces = [Annonces]()
    var user = Users()
    var userid : Int!
    @objc let username = UserDefaults.standard.string(forKey: "username")!
    @objc var url = String()
    @objc let myRedColor = UIColor(
        red:1.0,
        green:0.0,
        blue:0.0,
        alpha:1.0)
    @objc let blue = UIColor(
        red:76.0,
        green:200.0,
        blue:120.0,
        alpha:1.0)
    fileprivate let refresh = RainyRefreshControl()
    override func viewDidLoad() {
        
        //var url2 = ""
        super.viewDidLoad()
        let itemSize = UIScreen.main.bounds.width - 30
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsetsMake(20, 0, 10, 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize + 60 )
        
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        
        
        myCollectionView.collectionViewLayout = layout
        
        // handle user by username
        SwiftSpinner.show("Loading images from server...")
        
        ProfileServices.getCurrentUser(username: self.username) { (success,error, response) in
            if success{
                guard let userdb = response  else{
                    return
                }
                self.user=userdb
                self.userid = userdb.id!
                self.handleAnnoncesByUser()
                SwiftSpinner.hide()
                //url2 = URLS.GETURL+"rentagro/Annonces/getAnnonceByUser.php?user_id=\(self.user.id)"
            }
        }
        
        // Do any additional setup after loading the view.
        //
        navigationController?.navigationBar.barTintColor = UIColor.white
        refresh.addTarget(self, action: #selector(MyAdvertsViewController.doRefresh), for: .valueChanged)
        self.myCollectionView.addSubview(refresh)
        
    }
    
    @objc func doRefresh(){
        
        
        let popTime = DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            SwiftSpinner.show("Loading Adverts")
            self.myCollectionView.reloadData()
            self.refresh.endRefreshing()
            SwiftSpinner.hide()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        doRefresh()
        self.myCollectionView.reloadData()
        
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.annonces.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  myCollectionView.dequeueReusableCell(withReuseIdentifier: "myAdvertsCell", for: indexPath) as! tableViewCell
        
        
        
        cell.imgv.layer.cornerRadius = 100
        cell.btnShareRent.layer.cornerRadius = 0.05 * cell.btnShareRent.bounds.size.width
   //     cell.btnShareFacebook.layer.cornerRadius = 0.05 * cell.btnShareRent.bounds.size.width
        cell.btnRemoveRent.layer.cornerRadius = 0.05 * cell.btnShareRent.bounds.size.width
        
        
        let urlupload = URLS.GETURL+"upload/\(annonces[indexPath.row].imagesDir!)/0.jpeg"
        if let imageURL = URL(string: urlupload.replacingOccurrences(of: " ", with: "%20")), let placeholder = UIImage(named: "default-placeholder-300x300") {
            cell.imgv.af_setImage(withURL: imageURL, placeholderImage: placeholder)
        }
        
        
        
        if ((self.annonces[indexPath.row].validite == 1 ) && (self.annonces[indexPath.row].etat! == 1))
        {
            cell.lblValide.text = "valid"
            cell.lbleta.text = "This advert is shared "
            cell.btnRemoveRent.isEnabled = true
            cell.btnRemoveRent.layer.backgroundColor = UIColor(red:0.30, green:0.71, blue:0.67, alpha:1.0).cgColor
       //     cell.btnShareFacebook.isEnabled = true
        //    cell.btnShareFacebook.layer.backgroundColor = UIColor(red:0.30, green:0.71, blue:0.67, alpha:1.0).cgColor
            cell.btnShareRent.isEnabled = false
            cell.btnShareRent.layer.backgroundColor = UIColor.darkGray.cgColor
        }
        
        if ((self.annonces[indexPath.row].validite == 1 ) && (self.annonces[indexPath.row].etat! == 0))
        {
            cell.lblValide.text = "valid"
            cell.lbleta.text = "This advert is not shared "
        //    cell.btnShareFacebook.isEnabled = true
        //    cell.btnShareFacebook.layer.backgroundColor = UIColor(red:0.30, green:0.71, blue:0.67, alpha:1.0).cgColor
            cell.btnRemoveRent.isEnabled = false
            cell.btnShareRent.isEnabled = true
            cell.btnShareRent.layer.backgroundColor = UIColor(red:0.30, green:0.71, blue:0.67, alpha:1.0).cgColor
            cell.btnRemoveRent.layer.backgroundColor = UIColor.darkGray.cgColor
            
        }
        if ((self.annonces[indexPath.row].validite == 0 ) && (self.annonces[indexPath.row].etat! == 0))
        {
            cell.btnShareRent.isEnabled = false
            cell.btnShareRent.layer.backgroundColor = UIColor.darkGray.cgColor
            cell.btnRemoveRent.isEnabled = false
            cell.btnRemoveRent.layer.backgroundColor = UIColor.darkGray.cgColor
            cell.lbleta.text = "This advert is not shared "
     //       cell.btnShareFacebook.isEnabled = false
       //     cell.btnShareFacebook.layer.backgroundColor = UIColor.darkGray.cgColor
            cell.lblValide.text = "invalid"
        }
        
        
        
        cell.lbldescription.text = self.annonces[indexPath.row].description
        cell.lbltitre.text = self.annonces[indexPath.row].titre
        //share rent
        cell.btnShareRent.tag = self.annonces[indexPath.row].id!
        cell.btnShareRent.addTarget(self, action: #selector(sharerentTapped), for: UIControlEvents.touchUpInside)
        
        //remove rent
        cell.btnRemoveRent.tag = self.annonces[indexPath.row].id!
        cell.btnRemoveRent.addTarget(self, action: #selector(removeRentTapped(sender:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    
    
    //sharebutton
    
    @IBAction func shareButtonTaped(sender: UIButton)  {
        
    }
    
    //share advert in the app
    @IBAction func sharerentTapped(sender: UIButton)  {
        
        
        self.url = URLS.GETURL+"annonces/shareAnnonce.php?id=\(sender.tag)"
        print(sender.tag)
        SwiftSpinner.show("Sharing rent...")
        Alamofire.request(self.url).responseString{
            
            response in
            print(self.url)
            if response.result.isSuccess {
                
                print(response)
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                    
                }
                if response.result.isSuccess{
                    CDAlertView(title: "Advert shared", message: "Advert shared with success", type: .success).show()
                    self.handleAnnoncesByUser()
                    
                }
                
                
            }
            if response.result.isFailure{
                
                print(response.result.description)
            }
            
        }
        let popTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.myCollectionView.reloadData()
            SwiftSpinner.hide()
        }
    
    }
    // remove the advert from app func
    @IBAction func removeRentTapped(sender: UIButton)  {
        //removefromrentagro
        self.url = URLS.GETURL+"annonces/removefromrentagro.php?id=\(sender.tag)"
        print(sender.tag)
        SwiftSpinner.show("Removing rent...")
        Alamofire.request(self.url).responseString{
            
            response in
            print(self.url)
            if response.result.isSuccess {
                
                print(response)
                
                //self.displayMyAlert(mymessage: "A", mytitle: "", mybutton: "ok")
                self.handleAnnoncesByUser()
                
                
                if let json = response.result.value {
                    print("JSON: \(json)")
                    
                }
                if response.result.isSuccess{
                    CDAlertView(title: "Advert removed", message: "Advert removed with success!", type: .notification).show()
                }
                
                
            }
            if response.result.isFailure{
                
                print(response.result.description)
            }
            
        }
        let popTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.myCollectionView.reloadData()
            SwiftSpinner.hide()
        }
        
    }
    
    @objc func handleCurrentUser() {
        
        
        ProfileServices.getCurrentUser(username: self.username) { (success,error, response) in
            if success{
                guard let userdb = response  else{
                    return
                }
                self.user=userdb
                self.user.id = userdb.id
            }
            else{
                print("haha")
                print(error ?? "")
            }
        }
        
    }
    
    // get all the annonces from the user
    @objc func handleAnnoncesByUser()  {
        
        
        
        
        let paramters: Parameters = [
            "user_id" : self.user.id!
        ]
        
        
        print(paramters)
        let URL = URLS.GETURL+"annonces/getAnnonceByUser.php"
        Alamofire.request(URL, parameters: paramters).responseJSON(completionHandler: {response in
            
            print("happy1")
            switch response.result {
                
            case .failure(let error):
                print(error)
                print("happy2")
                return
                
            case .success(let value):
                let json = JSON(value)
                guard let dataarray = json["annonce"].array else {
                    print("happy3")
                    return
                }
                
                let user = Users()
                user.id = 52
                
                let typess = Type()
                typess.id=1
                
                let delegation = Delegation()
                delegation.id=1
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                self.annonces.removeAll()
                for data in dataarray{
                    
                    guard let data = data.dictionary else {
                        return
                    }
                    
                    print(data)
                    
                    let annonce = Annonces()
                    annonce.id = data["id"]?.intValue
                    annonce.nature=data["nature"]?.string ?? ""
                    annonce.description=data["description"]?.string ?? ""
                    annonce.prix=data["prix"]!.intValue
                    annonce.validite=data["validite"]!.intValue
                    annonce.duree=data["duree"]!.intValue
                    annonce.numTel=data["numTel"]!.intValue
                    annonce.etat=data["etat"]!.intValue
                    annonce.user = Users()
                    annonce.type = Type()
                    annonce.delegation = Delegation()
                    annonce.titre=data["titre"]?.string ?? ""
                    annonce.imagesDir = data["imagesdir"]?.string ?? ""
                    annonce.nbrimages = data["nbrimages"]!.intValue
                    print(annonce.imagesDir)
                    //annonce.nbrimages = data["nbrimages"]!.intValue
                    annonce.dateDebut=dateFormatter.date(from: data["dateDebut"]?.string ?? "")
                    
                    self.annonces.append(annonce)
                    print(self.annonces.count)
                    
                    
                }
                
            }
            //self.myActivityIndicator.stopAnimating()
        })
    }
    
    //share on rent agro
    
    
    
    
    @objc func displayMyAlert(mymessage:String,mytitle:String,mybutton:String)  {
        let alert = UIAlertController(title: mytitle, message: mymessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString(mybutton, comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

// index
extension UICollectionView {
    @objc func indexPathForView(view: AnyObject) -> IndexPath? {
        let originInCollectioView = self.convert(CGPoint.zero, from: (view as! UIView))
        return self.indexPathForItem(at: originInCollectioView) as IndexPath?
    }
}

class tableViewCell: UICollectionViewCell {
    
  //  @IBOutlet weak var btnShareFacebook: UIButton!
    @IBOutlet weak var btnRemoveRent: UIButton!
    @IBOutlet weak var btnShareRent: UIButton!
    @IBOutlet weak var imgv: UIImageView!
    @IBOutlet weak var lbltitre: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var btnshare: UIButton!
    @IBOutlet weak var lblValide: UILabel!
    @IBOutlet weak var lbleta: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imgv.layer.cornerRadius = 20
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
    }
    
    
    
}
