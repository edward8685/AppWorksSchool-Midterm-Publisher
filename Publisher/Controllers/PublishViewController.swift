//
//  PublishViewController.swift
//  Publisher
//
//  Created by Ed Chang on 2021/10/12.
//

import UIKit
import Firebase
import FirebaseFirestore

class PublishViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var contentTextField: UITextField!
    
    @IBAction func publishArcticle(_ sender: UIButton) {
        
        if authorInfo == nil {
            let controller = UIAlertController(title: "No Author Info", message: "Please Login or check your account", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            
        } else {
            
            addData()
            let controller = UIAlertController(title: "Publish Successfully!", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
        }
    }
    //-----------------------------------------author info-----------------------------------
    var authorInfo: [String : Any]?
    
    //    var authorInfo = [ "author": [
    //        "email": "wayne@school.appworks.tw", "id": "waynechen323",
    //        "name": "AKA小安老師"
    //    ]
    //    ]
    //-----------------------------------------author info-----------------------------------
    let db = Firestore.firestore()
    
    var inputDatas: [String] = ["","",""]
    
    var firebaseModel: [String : Any] = [:]
    
    let firebaseTimeStamp = FieldValue.serverTimestamp()
    let timeStamp = NSDate().timeIntervalSince1970
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        categoryTextField.delegate = self
        contentTextField.delegate = self
        view.backgroundColor = .clear
        navigationController?.isNavigationBarHidden = true
        
    }
    
    func addData() {
        let articles = db.collection("articles")
        let document = articles.document()
        let data: [String: Any] = [
            "author": [
                "email": "wayne@school.appworks.tw", "id": "waynechen323",
                "name": "AKA小安老師"
            ],
            "title": "\(inputDatas[0])",
            "content": "\(inputDatas[2])", "createdTime": NSDate().timeIntervalSince1970,
            "id": document.documentID,
            "category": "\(inputDatas[1])"
        ]
        document.setData(data) }
}

extension PublishViewController:  UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        inputDatas[0] = titleTextField.text ?? ""
        inputDatas[1] = categoryTextField.text ?? ""
        inputDatas[2] = contentTextField.text ?? ""
        print("Did end editing")
    }
}
