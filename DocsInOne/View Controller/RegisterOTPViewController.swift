//
//  RegisterOTPViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 14/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class RegisterOTPViewController: UIViewController {
    
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
    
    var timer = Timer()
    var time  = 60
    var phoneNumber : String? = nil
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resendButton.isHidden = true
        resendButton.isEnabled = false
        Shadow.applyShadowOnView(yourView: submitButton, radius: 20)
        Shadow.applyShadowOnView(yourView: cardView, radius: 10)
        
        timerLabel.text = "Resend OTP in \(time) second"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
        
        
        
    }
    
    
    @objc func timeCounter(){
        if(time > 0){
            time -= 1;
            timerLabel.text = "Resend OTP in \(time) second"
        }else{
            timerLabel.isHidden = true
            resendButton.isHidden = false
            resendButton.isEnabled = true
            
        }
    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID!,
            verificationCode: otpTextField.text!)
        
        Auth.auth().signIn(with: credential) { (authData, error) in
            if error != nil{
                print("error while registering new user \(error.debugDescription)")
                self.otpTextField.layer.borderWidth = 2.0
                self.otpTextField.layer.borderColor = UIColor.red.cgColor
            }else{
                
                print("Successfully    login -------------------->")
                
                
                // User was created successfully, now store the first name and last name
                let db = Firestore.firestore()
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyHHmmssSS"
                let uid = formatter.string(from: date)
                
                let ref = Database.database().reference().child("users").child("phnNum")
                
                ref.child(self.phoneNumber!).setValue(uid){
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        guard let homeViewController = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else {return}
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                    }
                }
            }
            
        }
    }
    
    
}
