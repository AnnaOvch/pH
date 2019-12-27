//
//  User.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/22/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import Foundation



struct User {
    var id: Int
    var token: String
    var username: String
    var email: String?
    var date: String?
    var sympthom: String?
    var isAdmin:Bool?
    var faceApparat:Bool?
    var salivaApparat:Bool?
    var idFace:Int?
    var idSaliva:Int?
    
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? Int,
            let token = json["token"] as? String,
            let username = json["username"] as? String
            
   
        else {
            return nil
        }

        self.id = id
        self.token = token
        self.username = username
        

    }

}

