//
//  API.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/17.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

protocol API {
    
    /// ログイン処理
    ///
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    ///   - callback: ログイン結果
    func login(email: String, password: String, callback: @escaping (LoginResponse?) ->())
    
    
    /// ユーザー登録処理
    ///
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    ///   - callback: 登録結果
    func register(email: String, password: String, callback: @escaping (LoginResponse?) ->())

    
    /// トークンの更新
    /// トークンの期限が1時間のため、定期的に更新の必要あり
    ///
    /// - Parameter callback: 更新結果
    func refreshToken(callback: @escaping (RefreshResponse?) ->())
    
    /// タスク一覧の取得
    ///
    /// - Parameter callback: 取得結果
    func fetchTask(callback: @escaping ([String: FetchTaskResponse]?, NSError?) -> ())

    /// タスクの作成
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - now: 作成日
    ///   - callback: 作成結果
    func createTask(title: String, now: String, callback: @escaping (TaskResponse?) ->())
    
    /// タスクの保存
    ///
    /// - Parameters:
    ///   - task: 保存対象のタスク
    ///   - callback: 保存結果
    func saveTask(task: Task, callback: @escaping (FetchTaskResponse?) ->())
    
    /// タスクの削除
    ///
    /// - Parameters:
    ///   - task: 削除対象のタスク
    ///   - callback: 削除結果
    func deleteTask(task: Task, callback: @escaping (FetchTaskResponse?) ->())
}
