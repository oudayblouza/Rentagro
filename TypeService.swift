//
//  TypeService.swift
//  RentAGRO
//
//  Created by Ouday Blouza on 08/01/2018.
//  Copyright © 2018 Blouza Ouday. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

public class TypeService {
    
    /*Class to get Data From DataBase throw Json Request*/
    /*get All tyypeService classed by categorie*/
    class func getByCategorie(categ : Categories, completion: @escaping (_ error: Error? , _ types: [Type]?)->Void){
        print(URLS.GETURL+"Type/Select_Type.php?categorie=\(String(describing: categ.id!))")
        let URL = URLS.GETURL+"Type/Select_Type.php?categorie=\(String(describing: categ.id!))"
        Alamofire.request(URL,encoding: URLEncoding.default).responseJSON(completionHandler: {response in
            
            
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                let json = JSON(value)
                guard let dataarray = json["type"].array else {
                    completion(nil,nil)
                    return
                }
                
                var types = [Type]()
                
                for data in dataarray{
                    
                    
                    guard let data = data.dictionary else {
                        return
                    }
                    
                    
                    let type = Type()
                    type.id = data["id"]?.int ?? 0
                    type.nom = data["nom"]?.string ?? ""
                    let cat = Categories()
                    cat.id = data["categorie_id"]?.int ?? 0
                    type.categorie=cat
                    
                    
                    types.append(type)
                }
                
                completion(nil,types)
                
                
                
            }
            
        })
        
    }
    
    /*get  tyypeService classed by name*/

    class func getByNom(typenom : String, completion: @escaping (_ error: Error? , _ type: Type?)->Void){
        let   typ = Type()
        print(URLS.GETURL+"Type/select_type_ByNom.php?nom="+typenom.replacingOccurrences(of: " ", with: "%20"))
        let URL = URLS.GETURL+"Type/select_type_ByNom.php?nom="+typenom
        
        Alamofire.request(URL).responseJSON(completionHandler: {response in
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                
                let json = JSON(value)
                
                guard let data = json["type"].dictionaryObject else {
                    completion(nil,nil)
                    return
                }
                
               
                typ.id = (data["id"] as AnyObject).intValue
                typ.nom = (data["nom"] as? String) ?? "untitled"
                let cat = Categories()
                cat.id = (data["categorie_id"] as AnyObject).intValue
                typ.categorie=cat
                completion(nil,typ)
                
            }})
        
    }
    /*get  tyypeService classed by id*/

    class func getById(id : Int, completion: @escaping (_ error: Error? , _ type: Type?)->Void){
        let   typ = Type()
        print(URLS.GETURL+"Type/select_type_ById.php?id=")
        let URL = URLS.GETURL+"Type/select_delegation_ById.php?id=\(id)"
        
        Alamofire.request(URL).responseJSON(completionHandler: {response in
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                
                let json = JSON(value)
                
                guard let data = json["type"].dictionaryObject else {
                    completion(nil,nil)
                    return
                }
                
                
                typ.id = (data["id"] as AnyObject).intValue
                typ.nom = (data["nom"] as? String) ?? "untitled"
                let cat = Categories()
                cat.id = (data["categorie_id"] as AnyObject).intValue
                typ.categorie=cat
                completion(nil,typ)
                
            }})
        
    }
}
