//
//  AuthRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import RealmSwift

class AuthRepository: Repository {
    typealias EntityType = Auth
    
    func login(email: String, password: String, callback: @escaping (NSError?) -> ()) {
        fatalError("AuthRepository.login(email:password:callback:) has not been implemented")
    }
    func register(email: String, password: String, callback: @escaping (NSError?) -> ()) {
        fatalError("AuthRepository.register(email:password:callback:) has not been implemented")
    }
    
    func refresh(callback: @escaping (NSError?) -> ()) {
        fatalError("AuthRepository.refresh(callback:) has not been implemented")
    }
}

