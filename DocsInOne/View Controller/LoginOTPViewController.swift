//
//  LoginOTPViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 16/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit

class LoginOTPViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
      @IBOutlet weak var resendButton: UIButton!
      @IBOutlet weak var timerLabel: UILabel!
      @IBOutlet weak var loginButton: UIButton!
     static var keyBoardHeight : CGFloat = 0.0
      
    
     // @IBOutlet weak var cardView: UIView!
      
      var timer = Timer()
      var time  = 60
      
      
      
      
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
      

   

}
