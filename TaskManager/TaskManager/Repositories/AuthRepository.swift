//
//  AuthRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import RealmSwift

protocol AuthRepository {
    func login(email: String, password: String, callback: @escaping (NSError?) -> ())
    func register(email: String, password: String, callback: @escaping (NSError?) -> ())
    func validateToken(callback: @escaping (NSError?) -> ())
}

