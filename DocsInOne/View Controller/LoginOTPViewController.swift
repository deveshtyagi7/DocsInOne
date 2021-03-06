//
//  LoginOTPViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 16/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit
import AudioToolbox
class LoginOTPViewController: UIViewController {
    
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    
    
    
    var timer = Timer()
    var time  = 60
    
    var phoneNum = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resendButton.isHidden = true
        resendButton.isEnabled = false
        Shadow.applyShadowOnView(yourView: loginButton, radius: 20)
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
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if otpTextField.text!.count < 6{
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            self.otpTextField.layer.borderWidth = 2.0
            self.otpTextField.layer.borderColor = UIColor.red.cgColor
        }
        else{
            AuthServices.otpVerification(withVerificationID: verificationID!, withOtp: otpTextField.text!, completion: {
                let storyboard = UIStoryboard(name: "HomeLoggedIn", bundle: nil)
                guard let homeLoggedInViewController = storyboard.instantiateViewController(identifier: "HomeLoggedInViewController") as? HomeLoggedInViewController else {return}
                setUserID(userid: self.phoneNum)
                self.navigationController?.pushViewController(homeLoggedInViewController, animated: true)
            }) { (err) in
                print(err!)
            }
    }
    }
    
    
    
}
