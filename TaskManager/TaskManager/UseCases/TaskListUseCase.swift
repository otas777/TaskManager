//
//  TaskListUseCase.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

/// タスクの一覧と詳細のロジック
class TaskListUseCase {

    private let taskRepository: TaskRepository
    private let authRepository: AuthRepository
    
    init(with taskRepository: TaskRepository, _ authRepository: AuthRepository) {
        self.taskRepository = taskRepository
        self.authRepository = authRepository
    }

    
    /// ログアウト処理
    func logout() {
        // ログイン情報とタスクをDBから削除
        self.taskRepository.deleteAll()
        self.authRepository.deleteAll()
    }
    
    /// 解放処理
    func release() {
        self.taskRepository.release()
    }
    
    /// 全てのタスクをDBから検索
    ///
    /// - Parameter changed: 検索結果
    func findAll(changed: @escaping ([Task]) -> ()) {
        self.taskRepository.release()
        return self.taskRepository.findAll(changed: changed)
    }
    
    /// 未完了のタスクをDBから検索
    ///
    /// - Parameter changed: 検索結果
    func findIncomplete(changed: @escaping ([Task]) -> ()) {
        self.taskRepository.release()
        return self.taskRepository.findIncomplete(changed: changed)
    }

    /// 完了済みのタスクをDBから検索
    ///
    /// - Parameter changed: 検索結果
    func findCompleted(changed: @escaping ([Task]) -> ()) {
        self.taskRepository.release()
        return self.taskRepository.findCompleted(changed: changed)
    }

    /// タスクをAPIから取得
    func fetchTask() {
        
        Loading.show()
        self.authRepository.validateToken { (error) in
            
            if let error = error {
                self.onApiCompleted(error)
                return
            }

            self.taskRepository.fetchTask(callback: self.onApiCompleted(_:))
        }
    }
    
    /// タスクの作成
    ///
    /// - Parameters:
    ///   - title: タスクのタイトル
    func createTask(title: String) {
        
        Loading.show()
        self.authRepository.validateToken { (error) in
            
            if let error = error {
                self.onApiCompleted(error)
                return
            }
            
            self.taskRepository.createTask(title: title, now: Date.now, callback: self.onApiCompleted(_:))
        }
    }
    
    /// タスクの保存
    ///
    /// - Parameters:
    ///   - task: 保存対象のタスク
    ///   - callback: 保存結果
    func saveTask(task: Task, callback: @escaping (NSError?) -> ()) {
        
        self.authRepository.validateToken { (error) in
            
            if let error = error {
                callback(error)
                Loading.dismiss()
                return
            }
            
            self.taskRepository.saveTask(task: task, callback: callback)
        }
    }
    
    /// APIの完了処理
    ///
    /// - Parameter error: エラー
    func onApiCompleted(_ error: NSError?) {
        Loading.dismiss()
        if let error = error {
            RootViewController.shared?.showAlert(title: "タスクエラー", message: error.domain)
        }

    }
}
