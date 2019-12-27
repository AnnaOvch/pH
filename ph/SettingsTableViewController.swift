//
//  SettingsTableViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/22/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var dateOfJoining: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    weak var delegate: TableProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        dateOfJoining.text = users[0].date
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("willAppear")
        userName.text = users[0].username
        email.text = users[0].email
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        switch indexPath {
        case [0,0]:
           delegate?.didSelected(indexPathRows: 0)
        case [0,1]:
            delegate?.didSelected(indexPathRows: 1)
        case [1,0]:
            delegate?.didSelected(indexPathRows: 2)
        default:
            break
        }
    }
    @IBAction func logOutButton() {
        if BackEnd.isConnectedToInternet() == false  {
                   AlertHelper.showAlert(inVC: self, title: "", msg: "No internet connection", handler: nil)
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = sb.instantiateViewController(withIdentifier: "logInVC") as! LogInViewController
            UIApplication.shared.windows.first?.rootViewController = loginViewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            users = []
            UserDefaults.standard.removeObject(forKey: "token")
           
        }
    }
    
   
//    func extractDate() {
//        let host = BackEnd.host + "user/" + String(users[0].id)
//        request(host,method: .get).responseJSON { request in
//            let jsonArray = request.result.value as! [String:Any]
//            let text = jsonArray["date_joined"] as! String
//            self.dateOfJoining.text = text
//        }
//    }
}

protocol TableProtocol: class {
    func didSelected(indexPathRows:Int)
}
