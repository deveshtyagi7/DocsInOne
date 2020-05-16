//
//  SignInAndRegisterViewController.swift
//  DocsInOne
//
//  Created by Devesh Tyagi on 13/05/20.
//  Copyright © 2020 deveshtyagi7. All rights reserved.
//

import UIKit

class SignInAndRegisterViewController: UIViewController {

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
    let storyboard = UIStoryboard(name: "SignInAndRegister", bundle: nil)
           guard let loginOTPViewController = storyboard.instantiateViewController(identifier: "LoginOTPViewController") as? LoginOTPViewController else {return}
           self.navigationController?.pushViewController(loginOTPViewController, animated: true)
        let mobileNumber = mobileNumberTextField.text
           
    }
    
}
