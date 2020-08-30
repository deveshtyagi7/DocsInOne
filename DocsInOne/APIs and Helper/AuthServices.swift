//
//  AuthServices.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 30/08/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
class AuthServices {
    
    
    static func otpVerification(withVerificationID  verificationID: String, withOtp otp : String , completion : @escaping () -> Void , OnError : @escaping (_ errorMsg : String?) ->Void ){
        let credential = PhoneAuthProvider.provider().credential(
                   withVerificationID: verificationID,
                   verificationCode: otp)
        Auth.auth().signIn(with: credential) { (authData, error) in
            if error != nil{
                OnError(error.debugDescription)
            }else{
                
                print("Successfully    login -------------------->")
                
                completion()

            }
            
        }
    }
    
    
    //Phone Number SignIn
    
    static func signIn(with phoneNum: String ,completion : @escaping () -> Void){
        // signing in
      //  Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNum, uiDelegate: nil) { (verificationID, error) in
            if error != nil{
                print("Error while verifying phone number during signing in\(error.debugDescription)")
            }
            else{
                // Saving verification id to local memmory
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                completion()
                
                
            }
        }
        
    }
   
    static func register(withPhoneNumber phoneNumber : String ,completion : @escaping () -> Void){
          let date = Date()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyyHHmmssSS"
                        let uid = formatter.string(from: date)
                        
                        let ref = Database.database().reference().child("users").child("phnNum")
                        
                        ref.child(phoneNumber).setValue(uid){
                            (error:Error?, ref:DatabaseReference) in
                            if let error = error {
                                print("Data could not be saved: \(error).")
                            } else {
                                completion()
        //                         UserDefaults.standard.set(true, forKey: "loggedIn")
        //                                   let storyboard = UIStoryboard(name: "HomeLoggedIn", bundle: nil)
        //                                   guard let homeLoggedInViewController = storyboard.instantiateViewController(identifier: "HomeLoggedInViewController") as? HomeLoggedInViewController else {return}
        //                                   self.navigationController?.pushViewController(homeLoggedInViewController, animated: true)
                            }
                        }
    }
    
    
    
    static func logout(completion : @escaping () -> Void , OnError : @escaping (_ errorMsg : String?) ->Void){
        
        do {
            try  Auth.auth().signOut()
            print("Sucessfully Logout")
            completion()
        }
        catch let logoutError{
            OnError(logoutError.localizedDescription)
        }
        
    }
    
    
}
