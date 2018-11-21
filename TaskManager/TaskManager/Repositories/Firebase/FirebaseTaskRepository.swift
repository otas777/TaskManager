//
//  FirebaseTaskRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/21.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

class FirebaseTaskRepository: TaskRepository {
    
    override func getTaskList(callback: @escaping (NSError) -> ()) {
        API.taskList { (list) in
            if let list = list {
                
                
                
            } else {
                let error = NSError(domain: "タスクの取得ができませんでした。", code: -1, userInfo: nil)
                callback(error)

            }
        }
    }
}
