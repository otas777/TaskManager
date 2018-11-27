//
//  RealmTask.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/27.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import RealmSwift

/// Realmのログイン情報
class RealmTask: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var memo = ""
    @objc dynamic var create_date = ""
    @objc dynamic var is_completed = false
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, response: FetchTaskResponse) {
        self.init()
        
        self.id = id
        self.title = response.title
        self.memo = response.memo
        self.create_date = response.create_date
        self.is_completed = response.is_completed
    }
    
    convenience init(task: Task) {
        self.init()
        self.id = task.id
        self.title = task.title
        self.memo = task.memo
        self.create_date = task.create_date
        self.is_completed = task.is_completed
    }
    
    func toEntity() -> Task {
        var task = Task()
        task.id = self.id
        task.title = self.title
        task.memo = self.memo
        task.create_date = self.create_date
        task.is_completed = self.is_completed
        return task
    }

}
