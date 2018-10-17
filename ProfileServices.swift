//
//  ProfileServices.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 28/11/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

public class ProfileServices
{
    /*Class to get Data From DataBase throw Json Request*/
    /*get current user data */

    class func getCurrentUser(username: String , completion: @escaping (_ success:Bool ,_ error: Error? , _ currentUser: Users?)->Void){
        
        DispatchQueue.global().async {
            let URL = URLS.GETURL+"GetUser.php?username="+username.replacingOccurrences(of: " ", with: "%20")
            print(URL)
            Alamofire.request(URL,encoding: URLEncoding.default).responseJSON(completionHandler: {response in
                
                
                switch response.result {
                    
                case .failure(let error):
                    completion(false,error,nil)
                    print(error)
                    return
                    
                case .success(let value):
                    let json = JSON(value)
                    guard let dataarray = json["user"].dictionary else {
                        
                        return
                    }
                    let user = Users()
                    print(dataarray)
                    
                    user.id = dataarray["id"]?.intValue
                    
                    user.username = dataarray["username"]?.string ?? ""
                    user.email = dataarray["email"]?.string ?? ""
                    print(user.email!+"azerty")
                    user.role = dataarray["roles"]?.string ?? ""
                    user.nom = dataarray["nom"]?.string ?? ""
                    user.prenom = dataarray["prenom"]?.string ?? ""
                    user.numtel = dataarray["numtel"]!.intValue
                 print(dataarray["numtel"]!.intValue)
                    print("zebbi")
                    completion(true,nil,user)
                    
                    
                    
                }
                
            })
        }
        
        
    }

    /*get All shops data*/

    class func getAllShops(completion: @escaping (_ success:Bool ,_ error: Error? , _ users: [Users]?)->Void){
        
        DispatchQueue.global().async {
            let URL = URLS.GETURL+"User/getAllShops.php"
            Alamofire.request(URL,encoding: URLEncoding.default).responseJSON(completionHandler: {response in
                
                
                switch response.result {
                    
                case .failure(let error):
                    completion(false,error,nil)
                    print(error)
                    return
                    
                case .success(let value):
                    let json = JSON(value)
                    guard let dataarray = json["user"].array else {
                        
                        return
                    }
                    var users = [Users]()
                    
                    for data in dataarray {
                        let user = Users()
                        print(dataarray)
                        
                        user.id = data["id"].intValue
                        
                        user.username = data["username"].string ?? ""
                        user.email = data["email"].string ?? ""
                        print(user.email!+"azerty")
                        user.role = data["roles"].string ?? ""
                        user.longitude = data["longitude"].string ?? ""
                        user.latitude = data["latitude"].string ?? ""
                        user.nom = data["nom"].string ?? ""
                        user.prenom = data["prenom"].string ?? ""
                        print(user.prenom!+"dzdzdzd")
                        users.append(user)
                        completion(true,nil,users)
                    }
                    
                    
                    
                    
                    
                }
                
            })
        }
        
        
    }
    
    
}
