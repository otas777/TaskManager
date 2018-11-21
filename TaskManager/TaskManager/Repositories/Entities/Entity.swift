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
    @objc var crateDate = ""
    @objc var updateDate = ""
    
    func update() {

        let now = Date.now
        if self.crateDate.isEmpty {
            self.crateDate = now
        }
        self.updateDate = now
    }
}
