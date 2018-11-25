//
//  Entity.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

import RealmSwift

class Entity: Object {
    @objc var create_date = ""
    @objc var update_date = ""
    
    func update() {

        let now = Date.now
        if self.create_date.isEmpty {
            self.create_date = now
        }
        self.update_date = now
    }
}
