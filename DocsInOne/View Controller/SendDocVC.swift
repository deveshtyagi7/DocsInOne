//
//  ViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 26/04/21.
//  Copyright © 2021 deveshtyagi7. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ProgressHUD
class SendDocVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var docs : [Docs] = [Docs](){
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserDocs()
        tableView.register(SendDocTableViewCell.nib, forCellReuseIdentifier: SendDocTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        var count = 0
        docs.forEach { (doc) in
            if doc.isSelected {
                count += 1
               
            }
        }
        if count == 0{
            showAlertMessage(vc: topMostController(), title: .Message, message: "Please select atleast one document.")
            return
        }else {
            showInputDialog(title: "Ready To Send", subtitle: "Please enter the client number!",
                            actionTitle: "Done", cancelTitle: "Cancel",
                            inputPlaceholder: "Client Number",
                            inputKeyboardType: .numberPad) { (cancel) in
                self.dismiss(animated: false)
            } actionHandler: { (phoneNum) in
                if let num = phoneNum, num.count == 10{
                    self.sendDocument()
                }else {
                    showAlertMessage(vc: topMostController(), title: .Message, message: "Please enter a correct number")
                }
            }

        }
    }
    
    func sendDocument(){
        
    }
    func fetchUserDocs(){
        ProgressHUD.show("Loading...")
        let ref = Database.database().reference().child("docs")
        
        if let phnNum = getUserID(){
            ref.child(phnNum).observeSingleEvent(of: .value) { (snap) in
                ProgressHUD.dismiss()
                if let dict = snap.value as? [String : String]{
                    var allDoc :[Docs] = [Docs]()
                    dict.forEach { (name, url) in
                        let doc = Docs(name: name, docUrl: url)
                        allDoc.append(doc)
                    }
                    self.docs = allDoc
                }
               
            }
        }
    }

}
extension SendDocVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SendDocTableViewCell.identifier) as? SendDocTableViewCell else {
            return UITableViewCell()
            
        }
        cell.doc = docs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        for(index , doc) in docs.enumerated(){
            if index == row {
                var newDoc = doc
                newDoc.isSelected.toggle()
                docs[index] = newDoc
                break
                
            }
        }
    }
}
struct Docs {
    let name : String
    var isSelected : Bool = false
    let docUrl : URL
    
    init(name : String, docUrl : String) {
        self.name = name
        self.docUrl = URL(string: docUrl)!
    }
}
