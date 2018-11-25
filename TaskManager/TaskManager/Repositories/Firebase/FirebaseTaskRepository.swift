//
//  FirebaseTaskRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/21.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

class FirebaseTaskRepository: TaskRepository {

    func fetchTask(callback: @escaping (NSError?) -> ()) {
        API.fetchTask { (map, error) in
            
            if let error = error {
//                let error = NSError(domain: "タスクの取得ができませんでした。", code: -1, userInfo: nil)
                callback(error)
                return
            }
            
            if let map = map {
                
                var list = [Entity]()
                for id in map.keys {
                    if let res = map[id] {
                        list.append(Task(id: id, response: res))
                    }
                }
                
                RealmUtil.add(list: list)
            }
            callback(nil)
        }
    }
    
    func createTask(title: String, now: String, callback: @escaping (NSError?) -> ()) {
        API.createTask(title: title, now: now) { (response) in
            if let response = response {
                
                let task = Task()
                task.id = response.name
                task.title = title
                task.task_create_date = now
                
                RealmUtil.add(entity: task)

                callback(nil)
            } else {
                let error = NSError(domain: "タスクの作成ができませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }
    
    func saveTask(task: Task, callback: @escaping (NSError?) -> ()) {
        API.saveTask(task: task) { (response) in
            if let _ = response {
                
                RealmUtil.add(entity: task)
                
                callback(nil)
                
            } else {
                let error = NSError(domain: "タスクの更新ができませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }
}
