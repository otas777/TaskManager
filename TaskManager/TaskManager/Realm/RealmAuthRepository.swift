//
//  RealmAuthRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

class RealmAuthRepository: AuthRepository {

    static var current: Auth? {
        let realmAuth: RealmAuth? = RealmUtil.findAll().first
        return realmAuth?.toEntity()
    }
    
    private var api: API!
    init(api: API) {
        self.api = api
    }

    func deleteAll() {
        RealmUtil.deleteAll(type: RealmAuth.self)
    }
    
    func login(email: String, password: String, callback: @escaping (NSError?) -> ()) {
        
        self.api.login(email: email, password: password) { (response) in
            if let response = response {
                // DBへ保存
                let auth = RealmAuth(response: response)
                RealmUtil.add(obj: auth)
                callback(nil)
                
            } else {
                let error = NSError(domain: "ログインできませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }
    
    func register(email: String, password: String, callback: @escaping (NSError?) -> ()) {
        
        self.api.register(email: email, password: password) { (response) in
            if let response = response {
                // DBへ保存
                let auth = RealmAuth(response: response)
                RealmUtil.add(obj: auth)
                callback(nil)
                
            } else {
                let error = NSError(domain: "登録できませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }
    
    func validateToken(callback: @escaping (NSError?) -> ()) {

        // ログイン状態をチェック
        guard let auth = RealmAuthRepository.current else {
            let error = NSError(domain: "ログインしてください。", code: -1, userInfo: nil)
            callback(error)
            return
        }
        
        if auth.isExpired {
            // トークンの期限切れのため更新
            self.api.refreshToken { (response) in
                if let response = response {
                    let auth = RealmAuth(response: response)
                    RealmUtil.add(obj: auth)
                    callback(nil)

                } else {
                    let error = NSError(domain: "トークンの更新ができませんでした。", code: -1, userInfo: nil)
                    callback(error)
                }
            }
            return
        }
        callback(nil)
    }
}
