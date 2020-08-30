//
//  RegisterOTPViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 14/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit

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
        
        AuthServices.otpVerification(withVerificationID: verificationID!, withOtp: otpTextField.text!, completion: {
            
            AuthServices.register(withPhoneNumber: self.phoneNumber!) {
                 UserDefaults.standard.set(true, forKey: "loggedIn")
                           let storyboard = UIStoryboard(name: "HomeLoggedIn", bundle: nil)
                           guard let homeLoggedInViewController = storyboard.instantiateViewController(identifier: "HomeLoggedInViewController") as? HomeLoggedInViewController else {return}
                           self.navigationController?.pushViewController(homeLoggedInViewController, animated: true)
            }
           
        }) {(error) in
            print("error while registering new user \(error)")
            self.otpTextField.layer.borderWidth = 2.0
            self.otpTextField.layer.borderColor = UIColor.red.cgColor
        }
        
    }
    
    
}
