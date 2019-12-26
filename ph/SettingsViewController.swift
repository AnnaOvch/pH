//
//  SettingsViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/22/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire
import MessageUI
//var info: [String] = [users[0].username]

class SettingsViewController: UIViewController,TableProtocol, UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate {
   
    @IBOutlet weak var viewUser: UIView!
    
    @IBOutlet weak var imageUser: UIImageView!
    let imagePicker = UIImagePickerController()
  
    
     override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
       
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "staticID" {
            let vc = segue.destination as! SettingsTableViewController
            vc.delegate = self
        }
        
    }
    
    func didSelected(indexPathRows: Int) {
        print("did selected \(indexPathRows)")
        let vc = UIStoryboard(name: "TabController", bundle: nil).instantiateViewController(identifier: "changeInfoVC") as! ChangeInfoViewController
        if indexPathRows == 0 {
            vc.titleE = "Change username"
            vc.oldInfo = String(users[0].username)
            self.present(vc,animated: true)
        } else if indexPathRows == 1 {
            vc.titleE = "Change email"
            vc.oldInfo = String(users[0].email ?? "")
            self.present(vc,animated: true)
        } else if indexPathRows == 2 {
            openEmailController()
        }
        
        
    }
    @IBAction func pickImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
                
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let image = pickedImage
            let imagView = UIImageView(image: image)
            imagView.frame = CGRect(x: 122, y: 32, width: 170, height: 170)
            imagView.layer.masksToBounds = true
            imagView.layer.cornerRadius = viewUser.bounds.width / 2
            self.view.addSubview(imagView)
        }
     
        dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsViewController {
    func  openEmailController() {
         let mailComposeViewController = configuredMailComposeViewController()
         if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
          } else {
            AlertHelper.showAlert(inVC: self, title: "", msg: "Sorry,can not send mail", handler: nil)
        }
    }
    
     func configuredMailComposeViewController() -> MFMailComposeViewController {
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["anna.ovchynnykova@nure.ua"])
            mailVC.setSubject("Complain")
            mailVC.setMessageBody("I want to complain about your service", isHTML: false)

            return mailVC
        }
    
 
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
     controller.dismiss(animated: true, completion: nil)
    }
}


