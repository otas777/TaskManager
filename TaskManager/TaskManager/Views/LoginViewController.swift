//
//  LoginViewController.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/18.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private var loginUseCase: LoginUseCase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginUseCase = LoginUseCase(loginDelegate: self, with: FirebaseAuthRepository())
        
        self.loginButton.layer.cornerRadius = 8
        self.registerButton.layer.cornerRadius = 8
    }
    
    deinit {
        print("LoginViewController deinit")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "ログイン", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - IBAction

extension LoginViewController {
    
    @IBAction func onLogin(_ sender: UIButton) {
        self.loginUseCase.login(email: self.emailField.text,
                                password: self.passwordField.text)
    }
    
    @IBAction func onRegister(_ sender: UIButton) {
        self.loginUseCase.register(email: self.emailField.text,
                                   password: self.passwordField.text)
    }
}

// MARK: - LoginDelegate

extension LoginViewController: LoginDelegate {
    
    func onLoginCompleted(_ error: NSError?) {
        if let error = error {
            self.showAlert(message: error.domain)
        } else {
            RootViewController.shared?.toTaskList()
        }
    }
}
