//
//  ReceivedDoc.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 30/04/21.
//  Copyright © 2021 deveshtyagi7. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ProgressHUD
class ReceivedDoc: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var receivedDocList :[ReceivedDocs] = [ReceivedDocs](){
        didSet{
            self.view.removeErrorLabel()
            if receivedDocList.count == 0{
                self.tableView.isHidden = true
                let font = UIFont(name: "Open Sans", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
                self.view.addErrorLabel("You have not received any documents yet!", textColor: #colorLiteral(red: 0.08033012599, green: 0.1485913098, blue: 0.3262429237, alpha: 1), fontData: font, yAxis: -30.0)
                
            }else{
                self.tableView.isHidden = false
                tableView.reloadData()
                self.view.removeErrorLabel()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchReceivedDocs()
        tableView.register(SendDocTableViewCell.nib, forCellReuseIdentifier: SendDocTableViewCell.identifier)
    }
    
    
    
    func fetchReceivedDocs(){
        ProgressHUD.show("Loading...")
        let ref = Database.database().reference().child("RecievedDoc")
        var docs : [ReceivedDocs] = [ReceivedDocs]()
        if let phnNum = getUserID(){
            ref.child(phnNum).observe(.value) { (snap) in
                ProgressHUD.dismiss()
                print("======> \(snap)")
                if let dict = snap.value as? [String : Any]{
                    print("Received doc list ==> \(dict)")
                    
                    
                    dict.forEach { (phonNum , docList) in
                        
                        var arryOfDocs: [Docs] = [Docs]()
                        if let doclist = docList as? [String :String]{
                            //  self.fetUserName(with: phnNum) { senderName in
                            doclist.forEach { (name, url) in
                                let doc = Docs(name: name, docUrl: url)
                                arryOfDocs.append(doc)
                            }
                            
                            
                            // let name = "\(phnNum)(\(senderName))"
                            print("phnNum ====> \(phonNum)")
                            let newReceivedList  = ReceivedDocs(senderName: phonNum, listOfDocs: arryOfDocs)
                            docs.append(newReceivedList)
                            //}
                            
                        }
                        
                    }
                    self.receivedDocList = docs
                    
                }
            } withCancel: { err in
                print(err)
            }
            
            
            
        }
        ProgressHUD.dismiss()
        receivedDocList = docs
    }
    
    
}

extension ReceivedDoc : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count ==> \(receivedDocList.count)")
        return receivedDocList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SendDocTableViewCell.identifier) as? SendDocTableViewCell else {
            return UITableViewCell()
            
        }
        cell.name = receivedDocList[indexPath.row].senderName
        cell.checkBoxImg.isHidden = true
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let listOfDoc = receivedDocList[indexPath.row].listOfDoc
        navigateToViewAllDoc(with : listOfDoc)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
    func navigateToViewAllDoc(with listOfDoc : [Docs]){
        guard let nav = ViewAllDocsVC.getStoryboardInstanceForNC(), let vc = nav.topViewController as? ViewAllDocsVC else { return }
        vc.listOfDocs = listOfDoc
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


struct ReceivedDocs {
    let senderName : String
    let listOfDoc : [Docs]
    
    init(senderName :String, listOfDocs : [Docs]) {
        self.senderName = senderName
        self.listOfDoc = listOfDocs
    }
}
