//
//  LoginUseCase.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

protocol LoginDelegate: class {
    func onLoginCompleted(_ error: NSError?)
}

class LoginUseCase {
    private weak var loginDelegate: LoginDelegate?
    private let authRepository: AuthRepository
    
    init(loginDelegate: LoginDelegate, with authRepository: AuthRepository) {
        self.loginDelegate = loginDelegate
        self.authRepository = authRepository
    }
    
    func login(email: String?, password: String?) {

        guard let email = email, let password = password,
            !email.isEmpty, !password.isEmpty else {

                let error = NSError(domain: "メールアドレスとパスワードを入力してください", code: -1, userInfo: nil)
                self.loginDelegate?.onLoginCompleted(error)
                return
        }
        
        Loading.show()
        self.authRepository.login(email: email, password: password) { (error) in
            self.loginDelegate?.onLoginCompleted(error)
            Loading.dismiss()
        }
    }
    
    func register(email: String?, password: String?) {

        guard let email = email, let password = password,
            !email.isEmpty, !password.isEmpty else {
                
                let error = NSError(domain: "メールアドレスとパスワードを入力してください", code: -1, userInfo: nil)
                self.loginDelegate?.onLoginCompleted(error)
                return
        }

        Loading.show()
        self.authRepository.register(email: email, password: password) { (error) in
            self.loginDelegate?.onLoginCompleted(error)
            Loading.dismiss()
        }
    }
}
