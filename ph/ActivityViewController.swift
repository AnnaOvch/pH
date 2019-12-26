//
//  ActivityViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/21/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire

//var numberOfSections:Int = 0

class ActivityViewController: UIViewController {

    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //numberOfComments()
        activityInd.color = .purple
        activityInd.startAnimating()
        print(email,password)
       // numberOfComments()
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline:.now()+1) { [weak self] in
          guard let self = self else {
            return
          }
            
            self.signIn(email: (self.email!), password: (self.password!))
            
            
            DispatchQueue.main.async { [weak self] in
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
                print("case 200")
                let jsonDict = responseJSON.result.value as! [String:Any]
                let curUser = User(json: jsonDict)
                
                guard let user = curUser else {AlertHelper.showAlert(inVC: self, title: "", msg:"Problem with user") {
                        alert in
                        self.dismiss(animated: true, completion: nil)
                    } ;return}
                print(user)
                
                users.append(user)
                print("users array \(user)")
                
                UserDefaults.standard.set(user.token, forKey:"token")
                

                let address1 = String(BackEnd.host) + "user/\(users[0].id)/"
                request(address1).responseJSON {responseJSON in
                    switch responseJSON.result {
                     case .success(let value):
                         let jsonArray = value as! [String: Any]
                         users[0].email = jsonArray["email"] as! String
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
                print(responseJSON.response?.statusCode)
                let jsonDict = responseJSON.result.value as! NSDictionary
                guard let error = jsonDict["error"] else {return}
                AlertHelper.showAlert(inVC: self, title: "", msg: error as! String) { alert in
                                 self.dismiss(animated: true, completion: nil)
                             }
                
                
                
                print("error")
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

//
//func numberOfComments() {
//          let host = BackEnd.host + "comment/list/"
//              request(host).responseJSON { response in
//                        switch response.result {
//                         case .success(let value):
//                         guard let jsonArray = response.result.value as? [[String: Any]] else { return }
//                         numberOfSect =  Int(jsonArray.count)
//                         case .failure(let error):
//                             print(error)
//                         }
//                     }
//
//
//       }
