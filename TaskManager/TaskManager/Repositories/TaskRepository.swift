//
//  TaskRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

protocol TaskRepository {
    
    /// タスクの全削除
    func deleteAll()
    
    /// 解放処理
    func release()
    
    /// DBからタスクの全件取得
    ///
    /// - Parameter changed: 取得結果・変更時のコールバック
    func findAll(changed: @escaping ([Task]) -> ())
    
    /// DBから未完了タスクの取得
    ///
    /// - Parameter changed: 取得結果・変更時のコールバック
    func findIncomplete(changed: @escaping ([Task]) -> ())

    /// DBから完了済みタスクの取得
    ///
    /// - Parameter changed: 取得結果・変更時のコールバック
    func findCompleted(changed: @escaping ([Task]) -> ())
    
    /// タスクをAPIから取得
    ///
    /// - Parameter callback: 取得結果
    func fetchTask(callback: @escaping (NSError?) -> ())
    
    /// タスクの作成
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - now: 作成日
    ///   - callback: 作成結果
    func createTask(title: String, now: String, callback: @escaping (NSError?) -> ())
    
    /// タスクの保存
    ///
    /// - Parameters:
    ///   - task: 保存対象
    ///   - callback: 保存結果
    func saveTask(task: Task, callback: @escaping (NSError?) -> ())
    
    /// タスクの削除
    ///
    /// - Parameters:
    ///   - task: 削除対象
    ///   - callback: 削除結果
    func deleteTask(task: Task, callback: @escaping (NSError?) -> ())
}

