//
//  Auth.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import RealmSwift

class Auth: Entity {
    
    static var current: Auth? {
        guard let realm = try? Realm() else {
            return nil
        }
        return realm.objects(Auth.self).first
    }
    
    @objc dynamic var localId = ""
    @objc dynamic var idToken = ""
    @objc dynamic var refreshToken = ""
    @objc dynamic var expiredDate: Date?
    
    override class func primaryKey() -> String? {
        return "localId"
    }
    
    var isExpired: Bool {
        if let expiredDate = self.expiredDate {
            return expiredDate < Date()
        }
        return false
    }
    
    convenience init(response: LoginResponse) {
        self.init()
        
        self.idToken = response.idToken
        self.refreshToken = response.refreshToken
        
        if let sec = TimeInterval(response.expiresIn) {
            self.expiredDate = Date().afterDate(sec: sec)
        }
        self.localId = response.localId
    }
    
    func set(response: RefreshResponse) {
        self.idToken = response.id_token
        self.refreshToken = response.refresh_token

        if let sec = TimeInterval(response.expires_in) {
            self.expiredDate = Date().afterDate(sec: sec)
        }
//        self.localId = response.user_id
        self.update()
    }
}
