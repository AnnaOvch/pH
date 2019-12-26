//
//  BackEnd.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/21/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import Foundation
import Alamofire

var users: [User] = []
var modeOfUser:Bool = false //светлая тема

struct BackEnd{
    static let host = "http://127.0.0.1:8000/en/api/v1/"
    let networkReachabilityManager = Alamofire.NetworkReachabilityManager(host: host)


    static func isConnectedToInternet() ->Bool {
         return NetworkReachabilityManager()!.isReachable
     }
 
}
