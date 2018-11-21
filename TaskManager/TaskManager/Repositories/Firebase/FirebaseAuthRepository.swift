//
//  FirebaseAuthRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

class FirebaseAuthRepository: AuthRepository {

    func login(email: String, password: String, callback: @escaping (NSError?) -> ()) {
        
        API.login(email: email, password: password) { (response) in
            if let response = response {
                let auth = Auth(response: response)
                RealmUtil.add(entity: auth)
                callback(nil)
                
            } else {
                let error = NSError(domain: "ログインできませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }
    
    func register(email: String, password: String, callback: @escaping (NSError?) -> ()) {
        
        API.register(email: email, password: password) { (response) in
            if let response = response {
                let auth = Auth(response: response)
                RealmUtil.add(entity: auth)
                callback(nil)
                
            } else {
                let error = NSError(domain: "登録できませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }
    
    func refresh(callback: @escaping (NSError?) -> ()) {
        
        API.refreshToken { (response) in
            if let response = response {
                RealmUtil.write { (realm) in
                    Auth.current?.set(response: response)
                }
                
            } else {
                let error = NSError(domain: "トークンの更新ができませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }

    
}
