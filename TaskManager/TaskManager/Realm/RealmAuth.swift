//
//  RealmAuth.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/27.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import RealmSwift

/// Realmのログイン情報
class RealmAuth: Object {

    @objc dynamic var localId = ""
    @objc dynamic var idToken = ""
    @objc dynamic var refreshToken = ""
    @objc dynamic var expiredDate: Date?
    
    override class func primaryKey() -> String? {
        return "localId"
    }
    
    convenience init(response: LoginResponse) {
        self.init()
        
        self.localId = response.localId
        self.idToken = response.idToken
        self.refreshToken = response.refreshToken
        
        if let sec = TimeInterval(response.expiresIn) {
            self.expiredDate = Date().afterDate(sec: sec)
        }
    }
    
    convenience init(response: RefreshResponse) {
        self.init()

        self.localId = response.user_id
        self.idToken = response.id_token
        self.refreshToken = response.refresh_token
        
        if let sec = TimeInterval(response.expires_in) {
            self.expiredDate = Date().afterDate(sec: sec)
        }
    }
    
    func toEntity() -> Auth {
        var auth = Auth()
        auth.localId = self.localId
        auth.idToken = self.idToken
        auth.refreshToken = self.refreshToken
        auth.expiredDate = self.expiredDate
        
        return auth
    }
}
