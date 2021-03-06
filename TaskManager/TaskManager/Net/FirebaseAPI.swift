//
//  FirebaseAPI.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/27.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import Alamofire

struct FirebaseApiURL {
    
    
    /// APIの情報
    static private let plist: NSDictionary? = {
        if let path = Bundle.main.path(forResource: "Firebase", ofType:"plist" ) {
            return NSDictionary(contentsOfFile: path)
        }
        return nil
    }()
    
    /// FirebaseのAPIキー
    static private let apiKey: String = {
        return plist?["apiKey"] as? String ?? ""
    }()
    
    /// FirebaseのdatabaseURL
    static private let databaseURL: String = {
        return plist?["databaseURL"] as? String ?? ""
    }()
    
    static let login = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=" + apiKey
    static let register = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=" + apiKey
    static let refreshToken = "https://securetoken.googleapis.com/v1/token?key=" + apiKey
    
    static func task(id: String? = nil) -> String {
        if let id = id {
            let base = databaseURL + "/tasks/%@/%@.json?auth=%@"
            let auth = RealmAuthRepository.current
            return String(format: base, (auth?.localId ?? ""), id, (auth?.idToken ?? ""))
        } else {
            let base = databaseURL + "/tasks/%@.json?auth=%@"
            let auth = RealmAuthRepository.current
            return String(format: base, (auth?.localId ?? ""), (auth?.idToken ?? ""))
        }
    }
    
}

class FirebaseAPI: API {
    
    let header = {
        return [
            "Content-Type": "application/json"
        ]
    }()
    
    func login(email: String, password: String, callback: @escaping (LoginResponse?) ->()) {

        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
        
        Alamofire.request(FirebaseApiURL.login,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
        }
    }
    
    func register(email: String, password: String, callback: @escaping (LoginResponse?) ->()) {

        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
        
        Alamofire.request(FirebaseApiURL.register,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
        }
    }

    func refreshToken(callback: @escaping (RefreshResponse?) ->()) {
        
        let parameters: [String: Any] = [
            "grant_type": "refresh_token",
            "refresh_token": (RealmAuthRepository.current?.refreshToken ?? "")
        ]
        
        Alamofire.request(FirebaseApiURL.refreshToken,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
        }
        
    }
    
    func fetchTask(callback: @escaping ([String: FetchTaskResponse]?, NSError?) -> ()) {
        
        Alamofire.request(FirebaseApiURL.task(),
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                
                if let error = response.error as NSError? {
                    callback(nil, error)
                    
                } else {
                    callback(JSONDecoder.decode(data: response.data), nil)
                }
        }
    }
    
    func createTask(title: String, now: String, callback: @escaping (TaskResponse?) ->()) {
        
        let parameters: [String: Any] = [
            "title": title,
            "memo": "",
            "create_date": now,
            "is_completed": false
        ]
        
        Alamofire.request(FirebaseApiURL.task(),
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
        }
    }
    
    func saveTask(task: Task, callback: @escaping (FetchTaskResponse?) ->()) {

        let parameters: [String: Any] = [
            "title": task.title,
            "memo": task.memo,
            "create_date": task.create_date,
            "is_completed": task.is_completed
        ]
        
        Alamofire.request(FirebaseApiURL.task(id: task.id),
                          method: .put,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
        }
    }
    
    func deleteTask(task: Task, callback: @escaping (FetchTaskResponse?) ->()) {
        
        Alamofire.request(FirebaseApiURL.task(id: task.id),
                          method: .delete,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
        }
    }
}
