//
//  RegisterViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 14/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class RegisterViewController: UIViewController {
    @IBOutlet weak var errorTextLabel: UILabel!
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var registerView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    
     //  let transition  = SlideUpTransition()
       var topView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Shadow.applyShadowOnView(yourView: registerView, radius: 10)
        Shadow.applyShadowOnView(yourView: nextButton, radius: 20)
       
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            errorTextLabel.textColor = .red
            errorTextLabel.text = "Enter your name"
            return
            
        }else if !mobileNumberTextField.text!.isValidContact{
            errorTextLabel.textColor = .red
            errorTextLabel.text = "Enter your correct Phone Number"
            return
        }else{
            
            
        let mobNum = "+91\(mobileNumberTextField.text!)"
        let name =  nameTextField.text!
            
            let ref =  Database.database().reference()
            ref.child("phnNum").observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChild(mobNum){
                    
                    self.errorTextLabel.textColor = .red
                    self.errorTextLabel.text = "Mobile number already registered with DocsInOne.You can login with this number"
                               return
                    
                }
                else{
                  
                    PhoneAuthProvider.provider().verifyPhoneNumber(mobNum, uiDelegate: nil) { (verificationID, error) in
                        if error != nil{
                            print("error while verifying mobile number during registration\(error.debugDescription)")
                            return
                        }else{
                            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                            UserDefaults.standard.set(name, forKey: "name")
                            let storyboard = UIStoryboard(name: "SignInAndRegister", bundle: nil)
                            guard let registerOTPViewController = storyboard.instantiateViewController(identifier: "RegisterOTPViewController") as? RegisterOTPViewController else  {return}
                            registerOTPViewController.phoneNumber = mobNum
                            
                            self.navigationController?.pushViewController(registerOTPViewController, animated: true)
                        }
                    }
                }
            }
            
            
    }
        
        

        
}

      
    

}
extension String {
    var isValidContact: Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        let isValidPhone = phoneTest.evaluate(with: self)
        return isValidPhone
    }
}

