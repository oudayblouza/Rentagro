//
//  DelegationService.swift
//  RentAgro
//
//  Created by Ouday Blouza on 22/11/2017.
//  Copyright © 2017 Ouday Blouza. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

public class DelegationService {
    /*Class to get Data From DataBase throw Json Request*/
    /*get All delegation classed by ville*/

    class func getByVille(vil : Ville, completion: @escaping (_ error: Error? , _ delegations: [Delegation]?)->Void){
        print(URLS.GETURL+"Delegation/Select_Del.php?ville=\(String(describing: vil.id!))")
        let URL = URLS.GETURL+"Delegation/Select_Del.php?ville=\(String(describing: vil.id!))"
        Alamofire.request(URL,encoding: URLEncoding.default).responseJSON(completionHandler: {response in
            
            
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                let json = JSON(value)
                guard let dataarray = json["delegation"].array else {
                    completion(nil,nil)
                    return
                }
                
                var delegations = [Delegation]()
                
                for data in dataarray{
                    
                    
                    guard let data = data.dictionary else {
                        return
                    }
                    
        
                    let delegation = Delegation()
                    delegation.id = data["id"]?.int ?? 0
                    delegation.nom = data["nom"]?.string ?? ""
              
                    
                    delegations.append(delegation)
                }
                
                completion(nil,delegations)
                
                
                
            }
            
        })
        
    }
    
    /*get All delegation classed by name*/

 
    class func getByNom(delnom : String, completion: @escaping (_ error: Error? , _ delegation: Delegation?)->Void){
        let   del = Delegation()
        let URL = URLS.GETURL+"Delegation/select_delegation_ByNom.php?nom="+delnom.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(URL).responseJSON(completionHandler: {response in
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):

                let json = JSON(value)
                
                guard let data = json["delegation"].dictionaryObject else {
                    completion(nil,nil)
                    return
                }
                
               del.id =  (data["id"] as AnyObject).intValue
               del.nom = (data["nom"] as? String) ?? "untitled"
                
                completion(nil,del)
                
            }})
        
    }
    
    /*get All delegation classed by id*/

    class func getById(id : Int, completion: @escaping (_ error: Error? , _ delegation: Delegation?)->Void){
        let   del = Delegation()
        let URL = URLS.GETURL+"Delegation/select_delegation_ById.php?id=\(id)"
        
        Alamofire.request(URL).responseJSON(completionHandler: {response in
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                
                let json = JSON(value)
                
                guard let data = json["delegation"].dictionaryObject else {
                    completion(nil,nil)
                    return
                }
                
                del.id =  (data["id"] as AnyObject).intValue
                del.nom = (data["nom"] as? String) ?? "untitled"
                
                completion(nil,del)
                
            }})
        
    }
    
}
