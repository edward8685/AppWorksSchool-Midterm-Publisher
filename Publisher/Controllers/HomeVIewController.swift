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
    
    let firebaseTimeStamp = FieldValue.serverTimestamp()
    let timeStamp = NSDate().timeIntervalSince1970

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        
        view.stickSubView(tableView)
        
        tableView.lk_registerCellWithNib(identifier: ArticleCell.identifier, bundle: nil)
    }


}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else {fatalError("Could not create Cell")}
        return cell
    }
    
    
}

