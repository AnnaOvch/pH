//
//  AparatsViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/27/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire

class AparatsViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var segmOutlet: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clos: (Int,Bool)->Void = { (num,isFace) in
             if ( isFace == true ) {
                               users[0].idFace = num
                               users[0].faceApparat = true
                               self.myLabel.text = "ID of apparat is \(num) "
             } else {
                               users[0].idSaliva = num
                               users[0].salivaApparat = true
            }
        }
        extractIdApparats(closure: clos)
   }
    
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
                       if users[0].faceApparat == true {
                            self.myLabel.text = "ID of apparat is \(users[0].idFace!) "
                       } else {
                            self.myLabel.text = "No apparat"
                        }
                                                            
                        
        } else {
            if users[0].salivaApparat == true {
                self.myLabel.text = "ID of apparat is \(users[0].idSaliva!) "
            } else {
                self.myLabel.text = "No apparat"
             }
        }
                   
                      
        
    }

   
    func extractIdApparats(closure: @escaping(Int,Bool)->Void) {
            let address1 = String(BackEnd.host) + "user/\(users[0].id)/"
                              request(address1).responseJSON {responseJSON in
                                  switch responseJSON.result {
                                   case .success(let value):
                                       let jsonArray = value as! [String: Any]
                                      
                                       if let faceAp = jsonArray["face_aparat"], let num = faceAp as? Int{
//                                       users[0].idFace = num
                                         //users[0].faceApparat = true
                                        closure(num,true)
                                          print("face aparat")
                                       }
                                       
                                       if let salivaAp = jsonArray["saliva_aparat"],let num = salivaAp as? Int {
                                         // users[0].idSaliva = num
                                          //users[0].salivaApparat = true
                                         closure(num,false)
                                          print("saliva aparat")
                                       }
                                  default:
                                    break
                                }
       
                    }
        
                 
    }
    

}
