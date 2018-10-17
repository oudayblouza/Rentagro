//
//  VilleService.swift
//  RentAgro
//
//  Created by Ouday Blouza on 22/11/2017.
//  Copyright © 2017 Ouday Blouza. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

public class VilleService {


    /*Class to get Data From DataBase throw Json Request*/
    /*get All ville classed by name*/
class func getByNom(vilnom : String, completion: @escaping (_ error: Error? , _ ville: Ville?)->Void){
    let   vil = Ville()
    let URL = URLS.GETURL+"Ville/select_ville_ByNom.php?nom="+vilnom

    Alamofire.request(URL).responseJSON(completionHandler: {response in
        switch response.result {
            
        case .failure(let error):
            completion(error,nil)
            print(error)
            return
            
        case .success(let value):
        
           let json = JSON(value)
           
           guard let data = json["ville"].dictionaryObject else {
            completion(nil,nil)
            return
           }

           vil.id =  (data["id"] as AnyObject).intValue
           vil.nom = (data["nom"] as? String) ?? "untitled"
      print(vil)
            completion(nil,vil)
      
        }})
   
}
    
    
    /*get All ville classed by id*/

    class func getById(vilid : Int, completion: @escaping (_ error: Error? , _ ville: Ville?)->Void){
        let   vila = Ville()
        let URL = URLS.GETURL+"Ville/select_ville_ById.php?nom=\(vilid)"
        print (URL)
        Alamofire.request(URL).responseJSON(completionHandler: {response in
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                
                let json = JSON(value)
                
                guard let data = json["ville"].dictionaryObject else {
                    completion(nil,nil)
                    return
                }
            
                vila.id =  (data["id"] as AnyObject).intValue
                vila.nom = (data["nom"] as? String) ?? "untitled"
          print(vila)
               completion(nil,vila)
                
            }})
      
}
}
