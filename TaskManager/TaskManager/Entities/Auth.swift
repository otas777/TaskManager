//
//  Auth.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

struct Auth {
    var localId = ""
    var idToken = ""
    var refreshToken = ""
    var expiredDate: Date?
    
    var isExpired: Bool {
        if let expiredDate = self.expiredDate {
            return expiredDate < Date()
        }
        return false
    }
}
