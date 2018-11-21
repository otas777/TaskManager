//
//  TaskRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

protocol TaskRepository {
    func getTaskList(callback: @escaping (NSError) -> ())
}

