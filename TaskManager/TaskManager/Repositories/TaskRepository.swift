//
//  TaskRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

class TaskRepository: Repository {
    typealias EntityType = Task
    
    private var authRepository: AuthRepository!
    
    func getTaskList(callback: @escaping (NSError) -> ()) {
        fatalError("TaskRepository.getTaskList(callback) has not been implemented")
    }
    
}

