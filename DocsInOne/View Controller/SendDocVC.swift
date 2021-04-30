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
            self.view.removeErrorLabel()
            if docs.count == 0{
                self.tableView.isHidden = true
                let font = UIFont(name: "Open Sans", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
                self.view.addErrorLabel("No Document Is Uploded Yet", textColor: #colorLiteral(red: 0.08033012599, green: 0.1485913098, blue: 0.3262429237, alpha: 1), fontData: font, yAxis: -30.0)
               
            }else{
                self.tableView.isHidden = false
                tableView.reloadData()
                self.view.removeErrorLabel()
            }
          
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
                ProgressHUD.show("Fetch Information")
                if let num = phoneNum, num.count == 10{
                    self.sendDocument(on : num )
                }else {
                    ProgressHUD.dismiss()
                    showAlertMessage(vc: topMostController(), title: .Message, message: "Please enter a correct number")
                }
            }
            
        }
    }
    
    func sendDocument(on phnNum : String){
        
        // Check if Number exists
        checkUserExist(with : phnNum) {[weak self] (isExists, name) in
            guard let strongSelf = self else { return }
            ProgressHUD.dismiss()
            // If exist -- take confirmation
            if isExists{
                // if confirm --- > Send Dock
              showMultipleActionMessage(vc: strongSelf,
                                        title: "Confirmation",
                                        message: "Are you sure want to share your document with \(name)",
                                        actionTitle1: "Yes", actionTitle2: "No") { (yes) in
                ProgressHUD.show("Sending...")
                var selectedDoc : [String : String] = [String : String]()
                    strongSelf.docs.forEach { (doc) in
                    if doc.isSelected {
                        let docName = doc.name
                        let location = "\(doc.docUrl)"
                        selectedDoc["\(docName)"] = location
                    }
                }
                print("all selected docs ===> \(selectedDoc)")
                strongSelf.shareDoc(with : phnNum ,selectedDoc : selectedDoc)
               
                //share doc
              } handler2: { (no) in
                //popup
              }

            }else {
                //not show error
                ProgressHUD.dismiss()
                showAlertMessage(vc: topMostController(), title: .Oops, message: "This phone number is not registered.")
            }
        }
        
        
    }
    func shareDoc(with phnNum :String,selectedDoc : [String : String]){
       
        
        let ref = Database.database().reference()
        let userid = getUserID()
        ref.child("RecievedDoc").child(phnNum).child(userid!).updateChildValues(selectedDoc) { (err, ref) in
            if err != nil{
                ProgressHUD.showSuccess("Sent")
            }
            else{
                ProgressHUD.dismiss()
            }
        }
    }
    func checkUserExist(with phnNum :String,completion: @escaping((Bool,String) -> ())){
        let ref = Database.database().reference()
        
        ref.child("phnNum").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild("+91\(phnNum)"){
               
                
                if let dict = snapshot.value as? [String : Any]{
                    let data = dict["+91\(phnNum)"] as! [String : String]
                    let name = data["Name"]
                    completion(true,name ?? "")
                }
                print("USer exist ===> \(snapshot.value)")
                completion(true, "")
            }
            else{
                print("USer  not exist")
                completion(false,"")
                
            }
        }
        
    }
    func fetchUserDocs(){
        ProgressHUD.show("Loading...")
        let ref = Database.database().reference().child("docs")
        var allDoc :[Docs] = [Docs]()
        if let phnNum = getUserID(){
            ref.child(phnNum).observeSingleEvent(of: .value) { (snap) in
                ProgressHUD.dismiss()
                if let dict = snap.value as? [String : String]{
                   
                    dict.forEach { (name, url) in
                        let doc = Docs(name: name, docUrl: url)
                        allDoc.append(doc)
                    }
                   
                }
                self.docs = allDoc
            }
        }
        ProgressHUD.dismiss()
       
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
