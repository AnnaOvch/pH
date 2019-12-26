//
//  CommentsViewController.swift
//  ph
//
//  Created by Анна Овчинникова  on 12/23/19.
//  Copyright © 2019 Анна Овчинникова . All rights reserved.
//

import UIKit
import Alamofire
var numberOfSect = 0
class CommentsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var commentsTableView: UITableView!
   
    private let refreshControlForTable = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.rowHeight = 100
         let c: (Int) -> Void = { number in
            numberOfSect = number
        }
        
         self.numberOfComments(completed: c)
        refreshControlForTable.addTarget(self, action: #selector(refreshAction), for: UIControl.Event.valueChanged)
        commentsTableView.addSubview(refreshControlForTable)
                            
        
   }
    
    @objc func refreshAction() {
        
        let c: (Int) -> Void = { number in
                 numberOfSect = number
             }
             
              self.numberOfComments(completed: c)
             refreshControlForTable.endRefreshing()
           
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
  
    
   
 
}

extension CommentsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentTableViewCell
        cell.layer.cornerRadius = 30
        cell.indexP = indexPath[0]
        return cell
    }
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return numberOfSect
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view:UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
           view.backgroundColor = .clear

           return view
    }
    
    
    
    func numberOfComments(completed: @escaping (Int)->Void) {
      let host = BackEnd.host + "comment/list/"
                   request(host).responseJSON { response in
                    
                             switch response.result {
                             case .success(let _):
                                     guard let jsonArray = response.result.value as? [[String: Any]] else { return }
                                     let number =  Int(jsonArray.count)
                                     completed(number)
                                     
                             case .failure(let _):
                                    AlertHelper.showAlert(inVC: self, title: "", msg: "Internal error", handler: nil)
                              }
                    DispatchQueue.main.async {
                        self.commentsTableView.reloadData()
                    }
                    
                    self.commentsTableView.isHidden = false
                 }
        
        
     }
    
    
}

extension CommentsViewController: AddCommentProtocol {
    func newComment(comment:String) {
        numberOfSect += 1
        let indexSet = IndexSet(arrayLiteral: numberOfSect-1)
        self.commentsTableView.beginUpdates()
        self.commentsTableView.insertSections(indexSet, with: .fade)
        self.commentsTableView.endUpdates()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "addComment" {
            let destination = segue.destination as! AddCommentViewController
            destination.delegate = self
        }
    }
    
    
}









