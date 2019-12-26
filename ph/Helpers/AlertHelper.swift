//
//  AlertHelper.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/21/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    static func showAlert(inVC: UIViewController,title: String, msg: String,handler:((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(action)
        inVC.present(alert, animated: true, completion: nil)
    }
}
