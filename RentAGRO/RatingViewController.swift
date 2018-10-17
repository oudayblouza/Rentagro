//
//  RatingViewController.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 06/01/2018.
//  Copyright © 2018 Blouza Ouday. All rights reserved.
//

import UIKit
import Cosmos
class RatingViewController: UIViewController {

    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var cosmosStarRating: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        self.commentTextField.isHidden = true
        self.commentTextField.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @objc func endEditing() {
        view.endEditing(true)
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
