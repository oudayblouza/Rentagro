//
//  AnnonceController.swift
//  RentAgro
//
//  Created by Ouday Blouza on 14/11/2017.
//  Copyright © 2017 Ouday Blouza. All rights reserved.
//

import UIKit

class AnnonceController: UIViewController,UITableViewDataSource,UITabBarDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    @objc var myArray = ["Engins & Machines","Outils","Divers"]
    @objc var myArrayImg = [#imageLiteral(resourceName: "tractor"),#imageLiteral(resourceName: "outillage"),#imageLiteral(resourceName: "semoule")]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArrayImg.count;
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let imgv:UIImageView = cell.viewWithTag(101) as! UIImageView
        let lbl:UILabel = cell.viewWithTag(102) as! UILabel
        lbl.text = myArray[indexPath.row]
        imgv.image=myArrayImg[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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

}
