//
//  PreferenceKeys.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/26.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

enum PreferenceKeys: String {
    case requestAuthorizeionAleady
    
    func set(value: Any) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }
    
    func get<T: Any>(def: T) -> T {
        return UserDefaults.standard.object(forKey: self.rawValue) as? T ?? def
    }
    
    func remove() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }
}
