//
//  CategorieService.swift
//  RentAGRO
//
//  Created by Ouday Blouza on 08/01/2018.
//  Copyright © 2018 Blouza Ouday. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

public class CategorieService {
    
    /*Class to get Data From DataBase throw Json Request*/
    /*get All categorie classed by name*/
    
    class func getByNom(categnom : String, completion: @escaping (_ error: Error? , _ categorie: Categories?)->Void){
        let   categ = Categories()
        print(URLS.GETURL+"categorie/select_categorie_ByNom.php?nom="+categnom.replacingOccurrences(of: " ", with: "%20"))
        let URL = URLS.GETURL+"categorie/select_categorie_ByNom.php?nom="+categnom.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(URL).responseJSON(completionHandler: {response in
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                
                let json = JSON(value)
                
                guard let data = json["categorie"].dictionaryObject else {
                    completion(nil,nil)
                    return
                }
                
                categ.id =  (data["id"] as AnyObject).intValue
                categ.nom = (data["nom"] as? String) ?? "untitled"
          
                completion(nil,categ)
                
            }})
        
    }
    
        /*get All categorie classed by id*/
    
    class func getById(categid : Int, completion: @escaping (_ error: Error? , _ categorie: Categories?)->Void){
        let   catega = Categories()
        let URL = URLS.GETURL+"categorie/select_categorie_Byid.php?nom=\(categid)"
        print (URL)
        Alamofire.request(URL).responseJSON(completionHandler: {response in
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                
                let json = JSON(value)
                
                guard let data = json["categorie"].dictionaryObject else {
                    completion(nil,nil)
                    return
                }
                
                catega.id =  (data["id"] as AnyObject).intValue
                catega.nom = (data["nom"] as? String) ?? "untitled"
                print(catega)
                completion(nil,catega)
                
            }})
        
    }
}
