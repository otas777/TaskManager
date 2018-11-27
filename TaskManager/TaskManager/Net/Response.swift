//
//  Response.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/19.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation


/// ログイン・新規登録のレスポンス
struct LoginResponse: Codable {
    var kind: String
    var idToken: String
    var email: String
    var refreshToken: String
    var expiresIn: String
    var localId: String
    var registered: Bool?
}


/// トークン更新のレスポンス
struct RefreshResponse: Codable {
    var expires_in: String
    var token_type: String
    var refresh_token: String
    var id_token: String
    var user_id: String
    var project_id: String
}


/// タスク作成のレスポンス
struct TaskResponse: Codable {
    var name: String
}


/// タスク取得・保存のレスポンス
struct FetchTaskResponse: Codable {
    var title = ""
    var memo = ""
    var create_date = ""
    var is_completed = false

}
