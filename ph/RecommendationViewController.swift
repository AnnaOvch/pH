//
//  RecommendationViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/26/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class RecommendationViewController: UIViewController {

    @IBOutlet weak var typeOfSkin: UILabel!
    
    @IBOutlet weak var adviceForSkin: UITextView!
    
    @IBOutlet weak var refreshOutlet: UIButton!
    
    @IBOutlet weak var text1: UILabel!
    
    @IBOutlet weak var text2: UILabel!
    
    
    
    let activityInd = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if users[0].isAdmin == true {
            typeOfSkin.text = "Sorry, you are admin\n Create profile of simple user"
            adviceForSkin.text = ""
            refreshOutlet.isHidden = true
            text1.isHidden = true
            text2.isHidden = true
        } else {
            characteristicsLoad()
        }
    }
    
    @IBAction func refreshButton(_ sender: UIButton) {
        activityInd.startAnimating()
        refr()
        
    }
    
    func characteristicsLoad() {
        if let ill = users[0].sympthom {
                   switch ill {
                   case "Сухая кожа":
                       typeOfSkin.text = "dry"
                       adviceForSkin.text = Advices.adviceForDry
                   case "Жирная кожа":
                       adviceForSkin.text = Advices.adviceForOily
                       typeOfSkin.text = "oily"
                   case "Нормальная кожа":
                       adviceForSkin.text = Advices.adviceForNormal
                       typeOfSkin.text = "normal"
                   default:
                       break
                   }
        }

    }
    
    func refr () {
        let address1 = String(BackEnd.host) + "user/\(users[0].id)/"
        request(address1).responseJSON {responseJSON in
                           switch responseJSON.result {
                            case .success(let value):
                                let jsonArray = value as! [String: Any]
                                if  let arr = jsonArray["sympthoms"] as? NSArray {
                                   if arr.count >= 1 {
                                       if let s = arr[0] as? NSDictionary,let str = s["title"] {
                                          users[0].sympthom = str as! String
                                           print(users[0].sympthom)
                                       }
                                   }
                               }
                           case .failure:
                            print("failure")
                           default:
                            break
                }
        }
        characteristicsLoad()
        activityInd.stopAnimating()
    }

}
