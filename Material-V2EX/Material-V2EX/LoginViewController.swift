//
//  LoginViewController.swift
//  Material-V2EX
//
//  Created by altair21 on 17/2/8.
//  Copyright © 2017年 altair21. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var closeButton: FabButton!
    @IBOutlet weak var loginButton: RaisedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func setupGesture() {
        let tapClose = UITapGestureRecognizer(target: self, action: #selector(closeTapped(sender:)))
        closeButton.addGestureRecognizer(tapClose)
        
        let tapLogin = UITapGestureRecognizer(target: self, action: #selector(loginTapped(sender:)))
        loginButton.addGestureRecognizer(tapLogin)
    }
    
    func closeTapped(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginTapped(sender: UITapGestureRecognizer) {
        
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
            return false
        } else if textField == passwordTextField {
            loginTapped(sender: UITapGestureRecognizer())
            return false
        } else {
            return true
        }
    }
}
