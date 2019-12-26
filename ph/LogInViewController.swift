//
//  ViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/21/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import RevealingSplashView
import Alamofire

class LogInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        setUpSplash()
  }

    @IBAction func logInButtonTapped() {
        if BackEnd.isConnectedToInternet() == false  {
            AlertHelper.showAlert(inVC: self, title: "", msg: "No internet connection", handler: nil)
                    
               }
        if checkFields() == true && BackEnd.isConnectedToInternet() {
            let activityVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "activityVc") as! ActivityViewController
            activityVC.email = userNameTextField.text!
            activityVC.password = passwordTextField.text!
            self.present(activityVC, animated: true)
        }
    }
    
}

    
   

extension LogInViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeHolderColor = .lightGray
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            passwordTextField.becomeFirstResponder()
        case 2:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.placeHolderColor = .white
        }
    }
}
extension LogInViewController {
    func setUpSplash() {
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "capsule")!,iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: UIColor(red:0.11, green:0.56, blue:0.95, alpha:1.0))
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.popAndZoomOut
        revealingSplashView.startAnimation()
    }
    
    func checkFields()->Bool {
        if (userNameTextField.text != "" && passwordTextField.text != "") == false {
            AlertHelper.showAlert(inVC: self, title: "", msg: "Check fields"){ alert in
                //return false
            }
            return false
        }
        return true
    }
}
extension UITextField{
   @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder!, attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
