//
//  annoncesService.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 17/11/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

public class AnnoncesService {
    /*Class to get Data From DataBase throw Json Request*/
    /*get All adverts classed by category*/
    class func getAllByCategory(category: Int,completion: @escaping (_ error: Error? , _ annonces: [Annonces]?)->Void){
        
        let URL = URLS.GETURL+"annonces/getAnnonceByCat.php?category=\(category)"
        Alamofire.request(URL,encoding: URLEncoding.default).responseJSON(completionHandler: {response in
            
            
            switch response.result {
                
            case .failure(let error):
                
                completion(error,nil)
                
                return
                
            case .success(let value):
                
                let json = JSON(value)
                guard let dataarray = json["annonce"].array else {
                    completion(nil,nil)
                    
                    return
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                var annonces = [Annonces]()
                for data in dataarray{
                    
                    guard let data = data.dictionary else {
                        return
                    }
                    
                    let annonce = Annonces()
                    
                    let user = Users()
                    user.id = data["user_id"]!.intValue
                    
                    let typess = Type()
                    typess.id=data["type_id"]!.intValue
                    
                    print(data["type_id"]!.intValue)
                    let delegation = Delegation()
                    delegation.id=data["delegation_id"]!.intValue
                    
                    annonce.id = data["id"]?.int ?? 0
                    annonce.nature=data["nature"]?.string ?? ""
                    annonce.description=data["description"]?.string ?? ""
                    annonce.prix=data["prix"]!.intValue
                    annonce.validite=data["validite"]!.intValue
                    annonce.duree=data["duree"]!.intValue
                    annonce.numTel=data["numTel"]!.intValue
                    annonce.etat=data["etat"]!.intValue
                    annonce.user = user
                    annonce.type = typess
                    annonce.delegation = delegation
                    annonce.imagesDir = data["imagesdir"]?.string ?? ""
                    annonce.nbrimages = data["nbrimages"]!.intValue
                    annonce.titre=data["titre"]?.string ?? ""
                    annonce.longitude=data["longitude"]!.doubleValue
                    annonce.latitude=data["lattitude"]!.doubleValue
                    annonce.renttype=data["renttype"]?.string ?? ""
                    annonce.dateDebut=dateFormatter.date(from: data["dateDebut"]?.string ?? "")
                    print(annonce.type?.id)
                    annonces.append(annonce)
                }
                
                completion(nil,annonces)
                
                
            }
            
        })
        
    }
    /*get All adverts classed by category and nature*/

    class func getAllByCategoryByNature(nature: String,category: Int,completion: @escaping (_ error: Error? , _ annonces: [Annonces]?)->Void){
        
        let URL = URLS.GETURL+"annonces/getAnnonceByCatType.php?category=\(category)&nature=\(nature)"
        Alamofire.request(URL,encoding: URLEncoding.default).responseJSON(completionHandler: {response in
            
            
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                let json = JSON(value)
                guard let dataarray = json["annonce"].array else {
                    completion(nil,nil)
                    
                    return
                }
                
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                
                var annonces = [Annonces]()
                
                for data in dataarray{
                    
                    
                    guard let data = data.dictionary else {
                        return
                    }
                    
                    print(data)
                    
                    
                    let annonce = Annonces()
                    let user = Users()
                    user.id = data["user_id"]!.intValue
                    
                    let typess = Type()
                    typess.id=data["type_id"]!.intValue
                    
                    let delegation = Delegation()
                    delegation.id=data["delegation_id"]!.intValue
                    annonce.id = data["id"]?.int ?? 0
                    annonce.nature=data["nature"]?.string ?? ""
                    annonce.description=data["description"]?.string ?? ""
                    annonce.prix=data["prix"]!.intValue
                    annonce.validite=data["validite"]!.intValue
                    annonce.duree=data["duree"]!.intValue
                    annonce.numTel=data["numTel"]!.intValue
                    annonce.etat=data["etat"]!.intValue
                    annonce.user = user
                    annonce.type = typess
                    annonce.delegation = delegation
                    annonce.imagesDir = data["imagesdir"]?.string ?? ""
                    annonce.nbrimages = data["nbrimages"]!.intValue
                    annonce.titre=data["titre"]?.string ?? ""
                    annonce.longitude=data["longitude"]!.doubleValue
                    annonce.latitude=data["lattitude"]!.doubleValue
                    annonce.renttype=data["renttype"]?.string ?? ""
                    
                    annonce.dateDebut=dateFormatter.date(from: data["dateDebut"]?.string ?? "")
                    annonces.append(annonce)
                }
                
                completion(nil,annonces)
                
                
                
            }
            
        })
        
    }
    
    /*search adverts*/

    
    class func searchAction(nature: String,category: Int,search: String,completion: @escaping (_ error: Error? , _ annonces: [Annonces]?)->Void){
        
        let URL = URLS.GETURL+"annonces/searchAnnonces.php?search=\(search)&category=\(category)&nature=\(nature)"
        Alamofire.request(URL,encoding: URLEncoding.default).responseJSON(completionHandler: {response in
            
            
            switch response.result {
                
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                let json = JSON(value)
                guard let dataarray = json["annonce"].array else {
                    completion(nil,nil)
                    
                    return
                }
                
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                
                var annonces = [Annonces]()
                
                for data in dataarray{
                    
                    
                    guard let data = data.dictionary else {
                        return
                    }
                    
                    print(data)
                    
                    
                    let annonce = Annonces()
                    
                    let user = Users()
                    user.id = data["user_id"]!.intValue
                    
                    let typess = Type()
                    typess.id=data["type_id"]!.intValue
                    print(data["type_id"]!.intValue)
                    let delegation = Delegation()
                    delegation.id=data["delegation_id"]!.intValue
                    annonce.id = data["id"]?.int ?? 0
                    annonce.nature=data["nature"]?.string ?? ""
                    annonce.description=data["description"]?.string ?? ""
                    annonce.prix=data["prix"]!.intValue
                    annonce.validite=data["validite"]!.intValue
                    annonce.duree=data["duree"]!.intValue
                    annonce.numTel=data["numTel"]!.intValue
                    annonce.etat=data["etat"]!.intValue
                    annonce.user = user
                    annonce.type = typess
                    annonce.delegation = delegation
                    annonce.imagesDir = data["imagesdir"]?.string ?? ""
                    annonce.nbrimages = data["nbrimages"]!.intValue
                    annonce.titre=data["titre"]?.string ?? ""
                    annonce.longitude=data["longitude"]!.doubleValue
                    annonce.latitude=data["lattitude"]!.doubleValue
                    annonce.renttype=data["renttype"]?.string ?? ""
                    
                    annonce.dateDebut=dateFormatter.date(from: data["dateDebut"]?.string ?? "")
                    annonces.append(annonce)
                }
                
                completion(nil,annonces)
                
                
                
            }
            
        })
        
    }
    /*gsearch for adverts*/

    class func searchAll(category: Int,search: String,completion: @escaping (_ error: Error? , _ annonces: [Annonces]?)->Void){
        
        let URL = URLS.GETURL+"annonces/searchAll.php?search=\(search)&category=\(category)"
        Alamofire.request(URL,encoding: URLEncoding.default).responseJSON(completionHandler: {response in
            
              print("hahahahahaseddi9"+response.description)
 
            switch response.result {
              
            case .failure(let error):
                completion(error,nil)
                print(error)
                return
                
            case .success(let value):
                let json = JSON(value)
                guard let dataarray = json["annonce"].array else {
                    completion(nil,nil)
                    
                    return
                }
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                
                var annonces = [Annonces]()
                
                for data in dataarray{
                    
                    
                    guard let data = data.dictionary else {
                        return
                    }
                    
                    print(data)
                    
                    
                    let annonce = Annonces()
                    
                    let user = Users()
                    user.id = data["user_id"]!.intValue
                    
                    let typess = Type()
                    typess.id=data["type_id"]!.intValue
                    
                    let delegation = Delegation()
                    delegation.id=data["delegation_id"]!.intValue
                    annonce.id = data["id"]?.int ?? 0
                    annonce.nature=data["nature"]?.string ?? ""
                    annonce.description=data["description"]?.string ?? ""
                    annonce.prix=data["prix"]!.intValue
                    annonce.validite=data["validite"]!.intValue
                    annonce.duree=data["duree"]!.intValue
                    annonce.numTel=data["numTel"]!.intValue
                    annonce.etat=data["etat"]!.intValue
                    annonce.user = user
                    annonce.type = typess
                    annonce.delegation = delegation
                    annonce.imagesDir = data["imagesdir"]?.string ?? ""
                    annonce.nbrimages = data["nbrimages"]!.intValue
                    annonce.titre=data["titre"]?.string ?? ""
                    annonce.longitude=data["longitude"]!.doubleValue
                    annonce.latitude=data["lattitude"]!.doubleValue
                    annonce.renttype=data["renttype"]?.string ?? ""
                    annonce.dateDebut=dateFormatter.date(from: data["dateDebut"]?.string ?? "")
                    annonces.append(annonce)
                }
                
                completion(nil,annonces)
                
                
                
            }
            
        })
        
    }
    
}
