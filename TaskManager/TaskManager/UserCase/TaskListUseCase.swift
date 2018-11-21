//
//  TaskListUseCase.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

protocol TaskListDelegate: class {
    func onGetTaskCompleted(error: NSError?)
}

class TaskListUseCase {

    private weak var taskListDelegate: TaskListDelegate?
    private let taskRepository: TaskRepository
    
    private let authRepository: AuthRepository
    
    init(taskListDelegate: TaskListDelegate, with taskRepository: TaskRepository, _ authRepository: AuthRepository) {
        self.taskListDelegate = taskListDelegate
        self.taskRepository = taskRepository
        self.authRepository = authRepository
    }

    func getTaskList() {
        
        guard let auth = Auth.current else {
            return
        }
        
        if auth.isExpired {
            // トークンの期限切れのため更新
            authRepository.refresh { (error) in
                if let error = error {
                    self.taskListDelegate?.onGetTaskCompleted(error: error)
                
                } else if Auth.current?.isExpired ?? true {
                    let error = NSError(domain: "トークンの更新ができませんでした。", code: -1, userInfo: nil)
                    self.taskListDelegate?.onGetTaskCompleted(error: error)

                } else {
                    self.getTaskList()
                }
            }
        }
        
        taskRepository.getTaskList { (error) in
            self.taskListDelegate?.onGetTaskCompleted(error: error)
        }
    }
}
