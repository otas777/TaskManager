//
//  Task.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

class Task: Entity {
    
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var reminder = ""
    @objc dynamic var task_create_date = ""
    @objc dynamic var is_completed = false


    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, response: FetchTaskResponse) {
        self.init()
        
        self.id = id
        self.title = response.title
        self.memo = response.memo
        self.reminder = response.reminder
        self.task_create_date = response.create_date
        self.is_completed = response.is_completed
        
    }
}


