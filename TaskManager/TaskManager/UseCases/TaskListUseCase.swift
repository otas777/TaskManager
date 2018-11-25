//
//  TaskListUseCase.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

class TaskListUseCase {

    private let taskRepository: TaskRepository
    private let authRepository: AuthRepository
    
    init(with taskRepository: TaskRepository, _ authRepository: AuthRepository) {
        self.taskRepository = taskRepository
        self.authRepository = authRepository
    }

    func fetchTask(callback: @escaping (NSError?) -> ()) {
        
        Loading.show()
        self.authRepository.validateToken { (error) in
            
            if let error = error {
                callback(error)
                Loading.dismiss()
                return
            }
            
            self.taskRepository.fetchTask { (error) in
                callback(error)
                Loading.dismiss()
            }
        }
    }
    
    func createTask(title: String, callback: @escaping (NSError?) -> ()) {
        
        Loading.show()
        self.authRepository.validateToken { (error) in
            
            if let error = error {
                callback(error)
                Loading.dismiss()
                return
            }
            
            self.taskRepository.createTask(title: title, now: Date.now) { (error) in
                callback(error)
                Loading.dismiss()
            }
        }
    }
    
    func saveTask(task: Task, callback: @escaping (NSError?) -> ()) {
        
        Loading.show()
        self.authRepository.validateToken { (error) in
            
            if let error = error {
                callback(error)
                Loading.dismiss()
                return
            }
            
            self.taskRepository.saveTask(task: task) { (error) in
                callback(error)
                Loading.dismiss()
            }
        }

    }
}
