//
//  HomeVIewController.swift
//  Publisher
//
//  Created by Ed Chang on 2021/10/12.
//

import UIKit
import Firebase
import FirebaseFirestore
import MJRefresh

class HomeViewController: UIViewController {
    
    @objc func publishNewArticle() {
        performSegue(withIdentifier: "toPublishPage", sender: nil)
    }
    
    let header = MJRefreshNormalHeader()
    
    private var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let db = Firestore.firestore()
    
    let toPublishPagebutton = UIButton()
    
    var dbModels: [[String : Any]] = []
    
    let firebaseTimeStamp = FieldValue.serverTimestamp()
    let timeStamp = NSDate().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        
        view.stickSubView(tableView)
        
        tableView.lk_registerCellWithNib(identifier: ArticleCell.identifier, bundle: nil)
        
        tableView.lk_registerCellWithNib(identifier: HeaderViewCell.identifier, bundle: nil)
        
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
        
        readData()
        
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        self.tableView.mj_header = header
    }
    
    override func viewWillLayoutSubviews() {
        setUpButton ()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        button.removeFromSuperview()
//    }
    
    
    @objc func headerRefresh(){
        readData()
        self.tableView.mj_header?.endRefreshing()
    }
    
    
    func readData() {
        dbModels = []
        db.collection("articles").order(by: "createdTime", descending: true).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("Error in read data. \(e)")
            } else {
                if let querySnapshot  = querySnapshot {
                    for document in querySnapshot.documents {
                        let data = document.data()
                        self.dbModels.append(data)
                    }
                    self.tableView.reloadData()
                }
                
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = Bundle.main.loadNibNamed(HeaderViewCell.identifier, owner: self, options: nil)?.first as? HeaderViewCell
        else {fatalError("Could not create HeaderView")}
        
        return headerView
    }
    
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
        
        
        cell.titleLabel.text = dbModels[indexPath.row]["title"] as? String
        guard let author = dbModels[indexPath.row]["author"] as? [String: Any],
              let name = author["name"] as? String else {fatalError("Can not get author name")}
        cell.nameLabel.text = name

        
        let category = dbModels[indexPath.row]["category"] as? String
        cell.categoryButton.setTitle(category, for: .normal)
        
        let timeInterval = dbModels[indexPath.row]["createdTime"]
        let date = Date(timeIntervalSince1970: timeInterval as! TimeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        let time = dateFormatter.string(from: date)
        print("\(time)")
        
        cell.timeLabel.text = time
        
        cell.contentLabel.text = dbModels[indexPath.row]["content"] as? String
        
        return cell
    }
    
    func setUpButton () {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        toPublishPagebutton.frame = CGRect(x: width - 70, y: height - 100, width: 50, height: 50)
        toPublishPagebutton.translatesAutoresizingMaskIntoConstraints = false
        toPublishPagebutton.backgroundColor = UIColor(red: 46 / 255 , green: 13 / 255 , blue: 128 / 255 , alpha: 1.00)
        let plusImage = UIImage(systemName: "plus")
        toPublishPagebutton.setImage(plusImage, for: .normal)
        toPublishPagebutton.tintColor = .white
        toPublishPagebutton.layer.cornerRadius = 25
        toPublishPagebutton.layer.masksToBounds = true
        
        toPublishPagebutton.addTarget(self, action: #selector(publishNewArticle), for: .touchUpInside)
        if let window = UIApplication.shared.keyWindow {
                window.addSubview(toPublishPagebutton)
            }
    }
    
    
}

