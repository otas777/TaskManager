//
//  RealmTaskRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/21.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTaskRepository: TaskRepository {
    
    private var api: API!
    
    private var notificationToken: NotificationToken?
    
    init(api: API) {
        self.api = api
    }

    func deleteAll() {
        RealmUtil.deleteAll(type: RealmTask.self)
    }
    
    func release() {
        self.notificationToken?.invalidate()
        self.notificationToken = nil
    }
    
    func findAll(changed: @escaping ([Task]) -> ()) {

        let list: Results<RealmTask> = RealmUtil.findAll().sorted(byKeyPath: "create_date", ascending: false)
        self.notificationToken = list.observe { (change) in
            changed(list.map { $0.toEntity() } )
        }
    }
    
    func findIncomplete(changed: @escaping ([Task]) -> ()) {

        let list: Results<RealmTask> = RealmUtil.find(format: "is_completed==NO").sorted(byKeyPath: "create_date", ascending: false)
        self.notificationToken = list.observe { (change) in
            changed(list.map { $0.toEntity() } )
        }
    }
    
    func findCompleted(changed: @escaping ([Task]) -> ()) {

        let list: Results<RealmTask> = RealmUtil.find(format: "is_completed==YES").sorted(byKeyPath: "create_date", ascending: false)
        self.notificationToken = list.observe { (change) in
            changed(list.map { $0.toEntity() } )
        }
    }

    func fetchTask(callback: @escaping (NSError?) -> ()) {
        
        self.api.fetchTask { (map, error) in
            
            if let error = error {
                callback(error)
                return
            }
            
            if let map = map {
                
                var list = [Object]()
                for id in map.keys {
                    if let res = map[id] {
                        list.append(RealmTask(id: id, response: res))
                    }
                }
                
                RealmUtil.add(list: list)
            }
            callback(nil)
        }
    }
    
    func createTask(title: String, now: String, callback: @escaping (NSError?) -> ()) {
        self.api.createTask(title: title, now: now) { (response) in
            if let response = response {
                
                let task = RealmTask()
                task.id = response.name
                task.title = title
                task.create_date = now
                
                RealmUtil.add(obj: task)

                callback(nil)
            } else {
                let error = NSError(domain: "タスクの作成ができませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }
    
    func saveTask(task: Task, callback: @escaping (NSError?) -> ()) {
        self.api.saveTask(task: task) { (response) in
            if let _ = response {
                // DBへ保存
                RealmUtil.add(obj: RealmTask(task: task))
                callback(nil)
                
            } else {
                let error = NSError(domain: "タスクの更新ができませんでした。", code: -1, userInfo: nil)
                callback(error)
            }
        }
    }
    
    func deleteTask(task: Task, callback: @escaping (NSError?) -> ()) {
        self.api.deleteTask(task: task) { (response) in
            
        }
    }
}
