//
//  Upload.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 08/03/21.
//  Copyright © 2021 deveshtyagi7. All rights reserved.
//

import Foundation
import FirebaseStorage
import ProgressHUD
import FirebaseDatabase
import FirebaseAuth
class UploadApi {
    func uploadDocToDatabase(docName : String,data : Data, onSucess : @escaping (_ imageUrl : String)-> Void){
        let docId = NSUUID().uuidString
        // let currentuserId = Auth.auth().currentUser?.uid ?? "sss"
        //        let uniqueId = Database.database().reference().child("users").child(currentuserId).observeSingleEvent(of: .value) { (snapshot) in
        //
        //        }
        
        if let userPhoneNum = getUserID(){
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF ).child(userPhoneNum).child(docName).child(docId)
            Storage.storage().reference(forURL: Config.STORAGE_ROOT_REF ).child(userPhoneNum).child(docName).delete { (error) in
                if error != nil {
                    print("Error while deleting")
                }
            }
            storageRef.putData(data, metadata: nil) { (metaData, error) in
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }else{
                    storageRef.downloadURL(completion: { (url, error) in
                        if let photoUrl = url?.absoluteString{
                            if let phoneNum = getUserID(){
                                Database.database().reference().child("docs").child(phoneNum).updateChildValues(["\(docName)" : "\(photoUrl)"])
                            }
                            onSucess(photoUrl)
                        }
                    })
                    
                    
                }
                
            }
            
        }
        
        
    }
}
