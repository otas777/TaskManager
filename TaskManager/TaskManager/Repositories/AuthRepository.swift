//
//  AuthRepository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation

protocol AuthRepository {
    
    /// 現在のログイン情報
    static var current: Auth? { get }
    
    /// ログイン情報の削除
    func deleteAll()
    
    /// ログイン処理
    ///
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    ///   - callback: ログイン結果
    func login(email: String, password: String, callback: @escaping (NSError?) -> ())
    
    
    /// ユーザー登録処理
    ///
    /// - Parameters:
    ///   - email: メールアドレス
    ///   - password: パスワード
    ///   - callback: 登録結果
    func register(email: String, password: String, callback: @escaping (NSError?) -> ())
    
    /// トークンの有効性をチェック
    ///
    /// - Parameter callback: チェック結果
    func validateToken(callback: @escaping (NSError?) -> ())
}

