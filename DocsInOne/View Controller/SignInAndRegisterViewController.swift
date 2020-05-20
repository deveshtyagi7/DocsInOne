//
//  SignInAndRegisterViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 13/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
import AudioToolbox
import FirebaseDatabase
import FirebaseAuth

class SignInAndRegisterViewController: UIViewController {

    @IBOutlet weak var mobileNumberUnderline: UIView!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var loginButton2: UIButton!
    @IBOutlet weak var loginViewCard: UIView!
    @IBOutlet weak var loginButton1: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Shadow.applyShadowOnView(yourView: loginButton1, radius: 20)
        Shadow.applyShadowOnView(yourView: registerButton, radius: 20)
      
        Shadow.applyShadowOnView(yourView: loginButton2, radius: 20)
    }
    override func viewWillAppear(_ animated: Bool) {
          loginViewCard.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        loginButton1.isEnabled = true
    }
    @IBAction func registerButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignInAndRegister", bundle: nil)
        guard let registerViewController = storyboard.instantiateViewController(identifier: "RegisterViewController") as? RegisterViewController else {return}
        self.navigationController?.pushViewController(registerViewController, animated: true)
        
    
    }
    

    @IBAction func loginButton1Pressed(_ sender: Any) {
        loginViewCard.isHidden = false
        
        loginButton1.isEnabled = false
       
        
    }
    
    @IBAction func loginButton2Pressed(_ sender: Any) {
        if !mobileNumberTextField.text!.isValidContact{
            mobileNumberUnderline.backgroundColor = .red
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
        }else{
             let mobNum = "+91\(mobileNumberTextField.text!)"
            
            //Cheching if user already exists or not
            
            let ref = Database.database().reference().child("users").child("phnNum")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                
                if snapshot.hasChild(mobNum){
                    // signing in
                    PhoneAuthProvider.provider().verifyPhoneNumber(mobNum, uiDelegate: nil) { (verificationID, error) in
                        if error != nil{
                            print("Error while verifying phone number during signing in\(error.debugDescription)")
                        }
                        else{
                            // Saving verification id to local memmory
                            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                            
                            // Redirecting to otp screen
                            let storyboard = UIStoryboard(name: "SignInAndRegister", bundle: nil)
                                  guard let loginOTPViewController = storyboard.instantiateViewController(identifier: "LoginOTPViewController") as? LoginOTPViewController else {return}
                                  self.navigationController?.pushViewController(loginOTPViewController, animated: true)
                        }
                    }
                    
                }
                else{
                    
                 //Redirecting to registration page
                    let storyboard = UIStoryboard(name: "SignInAndRegister", bundle: nil)
                    guard let registerViewController = storyboard.instantiateViewController(identifier: "RegisterViewController") as? RegisterViewController else {return}
                    self.navigationController?.pushViewController(registerViewController, animated: true)
                    
                }
            }
            
        }
        
    }
    
}
