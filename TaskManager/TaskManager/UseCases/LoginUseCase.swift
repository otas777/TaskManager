//
//  LoginUseCase.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

class LoginUseCase {
    
    private let authRepository: AuthRepository
    
    init(with  authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    /// ログイン処理
    ///
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    func login(email: String?, password: String?) {

        guard let email = email, let password = password,
            !email.isEmpty, !password.isEmpty else {
                let error = NSError(domain: "メールアドレスとパスワードを入力してください", code: -1, userInfo: nil)
                self.onLoginCompleted(error)
                return
        }
        
        Loading.show()
        self.authRepository.login(email: email, password: password, callback: self.onLoginCompleted(_:))
    }

    /// ユーザー登録処理
    ///
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    func register(email: String?, password: String?) {

        guard let email = email, let password = password,
            !email.isEmpty, !password.isEmpty else {
                
                let error = NSError(domain: "メールアドレスとパスワードを入力してください", code: -1, userInfo: nil)
                self.onLoginCompleted(error)
                return
        }

        Loading.show()
        self.authRepository.register(email: email, password: password, callback: self.onLoginCompleted(_:))
    }
    
    
    /// APIの完了処理
    ///
    /// - Parameter error: エラー
    func onLoginCompleted(_ error: NSError?) {
        Loading.dismiss()
        if let error = error {
            RootViewController.shared?.showAlert(title: "ログインエラー", message: error.domain)
        } else {
            RootViewController.shared?.toTaskList()
        }
    }

}
