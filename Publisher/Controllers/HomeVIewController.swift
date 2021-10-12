//
//  HomeVIewController.swift
//  Publisher
//
//  Created by Ed Chang on 2021/10/12.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let db = Firestore.firestore()
    
    var dbModels: [[String : Any]] = []
    
    let firebaseTimeStamp = FieldValue.serverTimestamp()
    let timeStamp = NSDate().timeIntervalSince1970

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        
        view.stickSubView(tableView)
        
        tableView.lk_registerCellWithNib(identifier: ArticleCell.identifier, bundle: nil)
        
        readData()
    }
    
    func readData() {
        dbModels = []
        db.collection("articles").getDocuments { (querySnapshot, error) in
            if let e = error {
                print("Error in read data. \(e)")
            } else {
                if let querySnapshot  = querySnapshot {
                    for document in querySnapshot.documents {
                        let data = document.data()
                        self.dbModels.append(data)
                    }
                    self.tableView.reloadData()
//                    print(self.dbModels)
                }
                
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Publisher"
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view =
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dbModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else {fatalError("Could not create Cell")}
        let author = dbModels[indexPath.row]["author"]
        print(author)
        cell.titleLabel.text = dbModels[indexPath.row]["title"] as? String
        
//        cell.nameLabel.text = author["name"] as? String
        cell.categoryLabel.text = dbModels[indexPath.row]["category"] as? String
        print(dbModels[indexPath.row]["category"])
        
        cell.timeLabel.text = dbModels[indexPath.row]["createdTime"] as? String
        print(dbModels[indexPath.row]["createdTime"])
        
        cell.contentLabel.text = dbModels[indexPath.row]["content"] as? String
        
        return cell
    }
    
    
}

