//
//  ActivityViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/21/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire

class ActivityViewController: UIViewController {

    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityInd.color = .purple
        activityInd.startAnimating()
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline:.now()+1) { [weak self] in
          guard let self = self else {
            return
          }
            
            self.signIn(email: (self.email!), password: (self.password!))
            DispatchQueue.main.asyncAfter(deadline:.now()+1) { [weak self] in
                self?.activityInd.stopAnimating()

            }
          
        }
       
    }
}
       
extension ActivityViewController {
    
    func signIn(email:String, password:String){
        let param = ["email":email,"password":password]
        let address = String(BackEnd.host) + "signin/"
        
        request(address, method:.post,parameters: param,encoding: JSONEncoding.default).responseJSON {responseJSON in
            switch responseJSON.response?.statusCode {
            case 200:
                let jsonDict = responseJSON.result.value as! [String:Any]
                let curUser = User(json: jsonDict)
                
                guard let user = curUser else {AlertHelper.showAlert(inVC: self, title: "", msg:"Problem with user") {
                        alert in
                        self.dismiss(animated: true, completion: nil)
                    } ;return}
                users.append(user)
                UserDefaults.standard.set(user.token, forKey:"token")
                let address1 = String(BackEnd.host) + "user/\(users[0].id)/"
                request(address1).responseJSON {responseJSON in
                    switch responseJSON.result {
                     case .success(let value):
                         let jsonArray = value as! [String: Any]
                         users[0].email = jsonArray["email"] as! String
                         users[0].date = jsonArray["date_joined"] as? String
                         users[0].isAdmin = jsonArray["is_staff"] as! Bool
                         if let faceAp = jsonArray["face_aparat"], let num = faceAp as? Int{
                            users[0].idFace = num
                            users[0].faceApparat = true
                            print("face aparat")
                         }
                         
                         if let salivaAp = jsonArray["saliva_aparat"],let num = salivaAp as? Int {
                            users[0].idSaliva = num
                            users[0].salivaApparat = true
                            print("saliva aparat")
                         }
                         if  let arr = jsonArray["sympthoms"] as? NSArray {
                            if arr.count >= 1 {
                                if let s = arr[0] as? NSDictionary,let str = s["title"] {
                                   users[0].sympthom = str as! String
                                    print(users[0].sympthom)
                                }
                            }
                        }
                            
                      case .failure(let error):
                        AlertHelper.showAlert(inVC: self, title: "", msg: "Error in extracting user email", handler: nil)
                     }
                    
                    
                }
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "TabController", bundle: nil).instantiateViewController(identifier: "tabNC") as! UITabBarController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc,animated: true)
                }
            
                
            case 404:
                AlertHelper.showAlert(inVC: self, title: "", msg: "No internet connection") { alert in
                    self.dismiss(animated: true, completion: nil)
                }
                
            case 400:
                let jsonDict = responseJSON.result.value as! NSDictionary
                guard let error = jsonDict["error"] else {return}
                AlertHelper.showAlert(inVC: self, title: "", msg: error as! String) {
                    alert in
                    self.dismiss(animated: true, completion: nil)
                }
            case 403:
                let jsonDict = responseJSON.result.value as! NSDictionary
                guard let error = jsonDict["error"] else {return}
                AlertHelper.showAlert(inVC: self, title: "", msg: error as! String) { alert in
                                 self.dismiss(animated: true, completion: nil)
                }
            default:
                AlertHelper.showAlert(inVC: self, title: "", msg:"no user") {
                    alert in
                    self.dismiss(animated: true, completion: nil)
                }
                break
            }
            
        }
     }
}
