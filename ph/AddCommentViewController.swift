//
//  AddCommentViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/24/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire

class AddCommentViewController: UIViewController {

    @IBOutlet weak var commentField: UITextField!
    
    
    weak var delegate: AddCommentProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentField.delegate = self
        commentField.becomeFirstResponder()
        commentField.clipsToBounds = false
        commentField.layer.shadowOpacity=0.4
        commentField.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @IBAction func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addComment() {
        let host = BackEnd.host + "comment/create/"
        guard let comment = commentField.text else {return }
        let parameters = ["client":String(users[0].id) , "text": String(comment)]
        request(host,method: .post,parameters: parameters)
                       .responseJSON { responseJSON in
                        print(responseJSON.result.value)
                        switch responseJSON.response?.statusCode{
                        case 201:
                            self.delegate?.newComment(comment: comment)
                            self.dismiss(animated: true, completion: nil)
                        default:
                            AlertHelper.showAlert(inVC: self, title: "", msg: "Error in adding comment", handler: nil)
                        }
                   }
    }
    @IBAction func editingChanges(_ sender: UITextField) {
        print("editingChanges")
        if commentField.text?.count ?? 0 > 30 {
            commentField.backgroundColor = .red
            AlertHelper.showAlert(inVC: self, title: "", msg: "Sorry, comment must le less than 30 characters long", handler: nil)
            
        } else {
            commentField.backgroundColor = .groupTableViewBackground
        }
    }
    
}
protocol AddCommentProtocol: class {
    func newComment(comment:String)
}
extension AddCommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentField.resignFirstResponder()
    }
    
}
