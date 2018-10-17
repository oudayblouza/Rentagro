//
//  userDefaultsManager.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 29/11/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import Foundation

extension UserDefaults
{
    /* define the user NSDEFAULT*/
    
    @objc func setIsLogedIn(value : Bool) {
        set(value, forKey: "isLoggedIn")
        synchronize()
    }
    
    @objc func isLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
    
    @objc func setUserName(value : String)  {
        set(value, forKey: "username")
        synchronize()
    }
    
    @objc func getUserName() -> String {
        return string(forKey: "username")!
    }
    
    @objc func setEmail(value : String)  {
        set(value, forKey: "email")
        synchronize()
    }
    
    @objc func getEmail() -> String {
        return string(forKey: "username")!
    }
    
    @objc func setName(value : String)  {
        set(value, forKey: "name")
        synchronize()
    }
    
    @objc func getName() -> String {
        return string(forKey: "name")!
    }
    
    @objc func setPass(value : String)  {
        set(value, forKey: "password")
        synchronize()
    }
    
    @objc func getPass() -> String {
        return string(forKey: "password")!
    }
    
    @objc func setTel(value : String)  {
        set(value, forKey: "telNum")
        synchronize()
    }
    
    @objc func getTel() -> String {
        return string(forKey: "telNum")!
    }
    
    
    @objc func setId(value : String)  {
        set(value, forKey: "id")
        synchronize()
    }
    @objc func getId() -> String {
        return string(forKey: "id")!
    }
    
    @objc func setRate(value : String)  {
        set(value, forKey: "rate")
        synchronize()
    }
    

    

    @objc func getRate() -> String {
        return string(forKey: "rate")!
    }
    
    @objc func setVoters(value : String)  {
        set(value, forKey: "voters")
        synchronize()
    }
    
    @objc func getVoters() -> String {
        return string(forKey: "voters")!
    }
}
