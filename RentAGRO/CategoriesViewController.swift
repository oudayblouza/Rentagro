//
//  CategoriesViewController.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 19/12/2017.
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
import FirebaseMessaging

class CategoriesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    
    @IBOutlet weak var tv: UITableView!
    fileprivate let refresh = RainyRefreshControl()
    var tableCategories = [Categories]()

    override func viewDidLoad() {
         super.viewDidLoad()
        
        
        Messaging.messaging().subscribe(toTopic: String("news"))
       

        // Loading all categories
        self.loadAllCategories()
        self.tv.reloadData()
        
        //design
        navigationController?.navigationBar.barTintColor = UIColor.white
        refresh.addTarget(self, action: #selector(CategoriesViewController.doRefresh), for: .valueChanged)
        self.tv.addSubview(refresh)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.loadAllCategories()
        Messaging.messaging().subscribe(toTopic: String("news"))
 

        self.tv.reloadData()
    }
    
    @objc func doRefresh(){
        
        let popTime = DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.tv.reloadData()
            self.refresh.endRefreshing()
        }
    }
    
    
    @objc func loadAllCategories() {
        SwiftSpinner.show("loading data")
        let url = URLS.GETURL+"categorie/select.php"
        Alamofire.request(url).responseJSON(completionHandler: {response in
            
            print("happy1")
            switch response.result {
                
            case .failure(let error):
                print(error)
                print("happy2")
                return
                
            case .success(let value):
                let json = JSON(value)
                guard let dataarray = json["categorie"].array else {
                    print("happy3")
                    return
                }
                print(dataarray)
                //self.tableCategories.removeAll()
                for data in dataarray{
                    
                    guard let data = data.dictionary else {
                        return
                    }
                    
                    print(data)
                    
                    let categorie = Categories()
                    categorie.id = data["id"]?.intValue
                    categorie.nom=data["nom"]?.string ?? ""
                    categorie.imageUrl=data["imageUrl"]?.string ?? ""
                    print(self.tableCategories.count)
                    print("ééééé")
                    
                    self.tableCategories.append(categorie)
                    
                    print(self.tableCategories.count)
                    
                    SwiftSpinner.hide()
                    
                }
                
            }
        })
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.tableCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tv.dequeueReusableCell(withIdentifier: "cellForCategory", for: indexPath)
        let imgv = cell.contentView.viewWithTag(1) as! UIImageView
        let lblNom = cell.contentView.viewWithTag(2) as! UILabel
       
        //imgv.image = #imageLiteral(resourceName: "default-placeholder-300x300")
        let urlupload = URLS.GETURL+self.tableCategories[indexPath.row].imageUrl!
        Alamofire.request(urlupload).responseImage { response in
            debugPrint(response)
            print(response.request ?? "")
            print(response.response ?? "")
            debugPrint(response.result)
            
            if let image = response.result.value {
                
                DispatchQueue.main.async {
                    print("image downloaded: \(image)")
                    imgv.image = image
                    
                }
                
                
            }
        }
        lblNom.text = self.tableCategories[indexPath.row].nom
        
        return cell
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "categoryId")
        {
            self.transitioningDelegate = RZTransitionsManager.shared()
            
            
            let yourNextViewController = (segue.destination as! ProfileViewController)
            yourNextViewController.transitioningDelegate = RZTransitionsManager.shared()
            let cell = sender as! UITableViewCell
            let indexPath = tv.indexPath(for: cell)
            
            print(self.tableCategories[(indexPath?.row)!].id!)
            yourNextViewController.idCat = self.tableCategories[(indexPath?.row)!].id!
            
            
        }
        
    }
    

}
