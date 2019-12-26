//
//  CommentTableViewCell.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/23/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire
class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var commentText: UILabel!
    
   
    var indexP = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        extractComment()
        
    }

  
    func extractComment() {
        let host = BackEnd.host + "comment/list/"
        var str = ""
          request(host).responseJSON { response in
             switch response.result {
             case .success(let _):
              guard let jsonArray = response.result.value as? [[String: Any]] else { return }
              str = jsonArray[self.indexP]["text"]! as! String
              self.commentText.text = str
              let id = jsonArray[self.indexP]["client"]! as! Int
              let host1 = BackEnd.host + "user/" + String(id) + "/"
                    request(host1).responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                let jsonArray = value as! [String: Any]
                                let username = jsonArray["username"] as! String
                                self.userName.text = username
                                
                                
                            case .failure(let error):
                                print(error.localizedDescription)
                        }
                
                    }
              case .failure(let error):
                  print(error)
              }
          }

    }
    
//    func extractUserName() {
//        
//    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
