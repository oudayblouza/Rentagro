//
//  Annonces.swift
//  RentAGRO
//
//  Created by Blouza Ouday on 17/11/2017.
//  Copyright © 2017 Blouza Ouday. All rights reserved.
//

import Foundation


class Annonces {
    
    var id: Int?
    var nature: String?
    var titre: String?
    var description: String?
    var prix: Int?
    var validite: Int?
    var dateDebut: Date?
    var duree: Int?
    var numTel: Int?
    var user: Users?
    var type: Type?
    var etat : Int?
    var imagesDir: String?
    var nbrimages: Int?
    var delegation: Delegation?
    var longitude: Double?
    var latitude: Double?
    var renttype: String?
    
    
   /* init(id: Int,nature: String,description: String,prix: Int,validite: Int,duree: Int,numTel: Int,user_id: Users,type_id: Type,delegation_id: Delegation,titre:String) {
        
        
        self.id=id
        self.nature=nature
        self.description=description
        self.prix=prix
        self.validite=validite
     
        self.duree=duree
        self.numTel=numTel
        self.user_id=user_id
        self.type_id=type_id
        self.delegation_id=delegation_id
        self.titre=titre
        
        
    }
    */
}
