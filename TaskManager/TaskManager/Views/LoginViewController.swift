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
        
        self.loginUseCase = LoginUseCase(with: RealmAuthRepository(api: FirebaseAPI()))
        
        self.loginButton.layer.cornerRadius = 8
        self.registerButton.layer.cornerRadius = 8
    }
    
    deinit {
        print("LoginViewController deinit")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailField.endEditing(true)
        self.passwordField.endEditing(true)
    }
}

// MARK: - IBAction

extension LoginViewController {
    
    /// ログインボタンのタップイベント
    ///
    /// - Parameter sender: ボタン
    @IBAction func onLogin(_ sender: UIButton) {
        self.loginUseCase.login(email: self.emailField.text,
                                password: self.passwordField.text)
    }

    /// 新規登録ボタンのタップイベント
    ///
    /// - Parameter sender: ボタン
    @IBAction func onRegister(_ sender: UIButton) {
        self.loginUseCase.register(email: self.emailField.text,
                                   password: self.passwordField.text)
    }
}
