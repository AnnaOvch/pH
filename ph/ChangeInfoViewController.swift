//
//  ChangeInfoViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/22/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire

class ChangeInfoViewController: UIViewController {
    
    var titleE: String? = nil
    var oldInfo: String? = nil
    var newData: String? = nil
    
    @IBOutlet weak var oldInfoLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newDataTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newDataTextField.addTarget(self,action: #selector(didChangeTextField), for: .editingChanged)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = titleE!
        oldInfoLabel.text = oldInfo!
        
    }
    @objc func didChangeTextField(_ textField:UITextField) {
        newData = textField.text
        print("new")
    }
    
    @IBAction func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton() {
        if newData == nil {
            AlertHelper.showAlert(inVC: self, title: "", msg: "Empty field", handler: nil)
        }
        let host = String(BackEnd.host) + "user/" + String(users[0].id) + "/"
       
        if self.titleE == "Change username" && newData != nil {
            let parameters = ["username":newData!]
            request(host,method: .patch,parameters: parameters)
                .responseJSON { responseJSON in
                    users[0].username = self.newData!
                    self.dismiss(animated: true, completion: nil)
            }
        } else if self.titleE == "Change email" && newData != nil {
            if isValidEmail(emailStr: newData!) == true {
                let parameters = ["email":newData!]
                           request(host,method: .patch,parameters: parameters)
                               .responseJSON { responseJSON in
                                   users[0].email = self.newData!
                                   self.dismiss(animated: true, completion: nil)
                           }
            } else {
                AlertHelper.showAlert(inVC: self, title: "", msg: "Email is not valid", handler: nil)
            }
           
        }
        
        
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    


}
