//
//  DemoTableViewController.swift
//  TestCollectionView
//
//  Created by Alex K. on 24/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit
import expanding_collection
import Alamofire
import AlamofireImage
import SwiftyJSON
import SwiftSpinner
import CDAlertView
import PopupDialog

class DemoTableViewController: ExpandingTableViewController {
    
    var annonces = [Annonces]()
    var countryString = String()
    var streetString = String()
    var id = Int()
    
    
    @IBOutlet var myTableView: UITableView!
    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleAnnoncesByUser()
        self.myTableView.reloadData()
        self.myTableView.rowHeight = 130
        configureNavBar()
        let image1 = Asset.backgroundImage.image
        tableView.backgroundView = UIImageView(image: image1)
    }
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleImageViewXConstraint: NSLayoutConstraint!
    
}

// MARK: - Lifecycle
extension DemoTableViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let titleView = navigationItem.titleView else { return }
        let center = UIScreen.main.bounds.midX
        let diff = center - titleView.frame.midX
        titleImageViewXConstraint.constant = diff
    }
    
}

// MARK: Helpers
extension DemoTableViewController {
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }
    
}

// MARK: Actions
extension DemoTableViewController {
    
    @IBAction func backButtonHandler(_ sender: AnyObject) {
        // buttonAnimation
        let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate
extension DemoTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //    if scrollView.contentOffset.y < -25 {
        //      // buttonAnimation
        //      let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
        //
        //      for viewController in viewControllers {
        //        if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
        //          rightButton.animationSelected(false)
        //        }
        //      }
        //      popTransitionAnimation()
        //    }
        
        scrollOffsetY = scrollView.contentOffset.y
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.annonces.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell")!
            let imgv = cell.contentView.viewWithTag(501) as! UIImageView
            let imgStars = cell.contentView.viewWithTag(502) as! UIImageView
            let lblLoc = cell.contentView.viewWithTag(503) as! UILabel
            
            //show  l'alerte de rating
            let tap = UITapGestureRecognizer(target: self, action: #selector(DemoTableViewController.imageStarsAction))
            imgStars.addGestureRecognizer(tap)
            imgStars.isUserInteractionEnabled = true
            
            
            
            lblLoc.text = self.countryString+","+self.streetString
            print(lblLoc.text ?? "seddik")
            imgStars.image = #imageLiteral(resourceName: "stars")
            imgv.image = #imageLiteral(resourceName: "map")
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cellAnnonces")!
            let imgv = cell.contentView.viewWithTag(401) as! UIImageView
            let description = cell.contentView.viewWithTag(405) as! UILabel
            let titre = cell.contentView.viewWithTag(402) as! UILabel
            let dateAjout = cell.contentView.viewWithTag(403) as! UILabel
            titre.text = annonces[indexPath.row - 1].titre
            
            description.text = annonces[indexPath.row - 1].description
            
            //upload image
            let urlupload = URLS.GETURL+"upload/\(annonces[indexPath.row - 1].imagesDir!)/0.jpeg"
            
            if let imageURL = URL(string: urlupload.replacingOccurrences(of: " ", with: "%20")), let placeholder = UIImage(named: "default-placeholder-300x300") {
                imgv.af_setImage(withURL: imageURL, placeholderImage: placeholder)
            }
            
            imgv.layer.cornerRadius = imgv.frame.size.height / 2
            imgv.layer.borderWidth = 3.0
            imgv.layer.borderColor = UIColor.white.cgColor
            imgv.clipsToBounds = true
        }
        return cell
    }
    
    //handle annonces by user shopppp
    func handleAnnoncesByUser()  {
        SwiftSpinner.show("Loading this shop's adverts")
        let paramters: Parameters = [
            "user_id" : self.id
        ]
        
        
        print(paramters)
        let URL = URLS.GETURL+"annonces/getAnnonceByUser.php"
        Alamofire.request(URL, parameters: paramters).responseJSON(completionHandler: {response in
            print(self.id)
            print("happy1")
            switch response.result {
                
            case .failure(let error):
                print(error)
                print("happy2")
                let alert = CDAlertView(title: "no adverts", message: "this shop is empty now", type: .error)
                let nevermindAction = CDAlertViewAction(title: "Nevermind 😑")
                alert.add(action: nevermindAction)
                alert.show()
                SwiftSpinner.hide()
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
            SwiftSpinner.hide()
        })
    }
    
    
    @objc func imageStarsAction()  {
        print("Image selected")
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "RATE", height: 60) {
            SwiftSpinner.show("Loading")
            let paramters: Parameters=[
                "id" : self.id,
                "rate" : ratingVC.cosmosStarRating.rating,
                
                ]
            
            Alamofire.request(URLS.GETURL+"User/Update_users_rate.php", parameters: paramters).responseString{
                response in
                print(response.description)
                if response.value! == "success" {
                    SwiftSpinner.hide()
                    CDAlertView(title: "Success", message: "Rating with success", type: .success).show()
                    print(response.result.description)
                }else{
                    SwiftSpinner.hide()
                    CDAlertView(title: "Alert", message: "Connexion Error", type: .error).show()
                    print(response.result.description)
                }
            }
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: true, completion: nil)
    }
    
    
    
}
