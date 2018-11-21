//
//  API.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/17.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

struct ApiURL {
    
    static private let plist: NSDictionary? = {
        if let path = Bundle.main.path(forResource: "Firebase", ofType:"plist" ) {
            return NSDictionary(contentsOfFile: path)
        }
        return nil
    }()
    
    static private let apiKey: String = {
        return plist?["apiKey"] as? String ?? ""
    }()

    static private let databaseURL: String = {
        return plist?["databaseURL"] as? String ?? ""
    }()
    
    static let login = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=" + apiKey
    static let register = "https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=" + apiKey
    static let refreshToken = "https://securetoken.googleapis.com/v1/token?key=" + apiKey

    static var task: String {
        let base = databaseURL + "/tasks/%@.json?auth=%@"
        let auth = Auth.current
        return String(format: base, (auth?.localId ?? ""), (auth?.idToken ?? ""))
    }
}

class API {
    
    static let header = {
        return [
            "Contenttype": "application/json"
        ]
    }()
    
    static func login(email: String, password: String, callback: @escaping (LoginResponse?) ->()) {

//    curl 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyB7BzMX8wpGGpYPy3tCJuSvOMcNIsUiVBc' \
//    -H 'Content-Type: application/json' \
//    --data-binary '{"email":"chaos.eden777+todo1@gamil.com","password":"abcd1234","returnSecureToken":true}'

        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]

        Loading.show()
        print(ApiURL.login)
        Alamofire.request(ApiURL.login,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)

            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
                Loading.dismiss()
        }
    }
    
    static func register(email: String, password: String, callback: @escaping (LoginResponse?) ->()) {
//        curl 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyB7BzMX8wpGGpYPy3tCJuSvOMcNIsUiVBc' \
//        -H 'Content-Type: application/json' \
//        --data-binary '{"email":"chaos.eden777+todo1@gamil.com","password":"abcd1234","returnSecureToken":true}'
        
        let parameters: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]
        
        Loading.show()
        Alamofire.request(ApiURL.register,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
                Loading.dismiss()
        }

    }
    
    static func createTask(callback: @escaping ([String: Any]) ->()) {
//        curl -X PUT -d '{
//        "alanisawesome2": {
//            "name": "Alan Turing",
//            "birthday": "June 23, 1912"
//        }
//    }' 'https://todo-cd263.firebaseio.com/users.json?print=pretty'
        
        let parameters: [String: Any] = [
            "name": "Alan Turing3",
            "birthday3": "June 23, 1912"
        ]

        Alamofire.request(ApiURL.task,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)

            .responseJSON { response in
                
                if let result = response.result.value as? [String: Any] {
                    callback(result)
                    print(result)
                }
        }
    }
    
    static func refreshToken(callback: @escaping (RefreshResponse?) ->()) {

        // sample
//        curl 'https://securetoken.googleapis.com/v1/token?key=[API_KEY]' \
//        -H 'Content-Type: application/x-www-form-urlencoded' \
//        --data 'grant_type=refresh_token&refresh_token=[REFRESH_TOKEN]'
        
        let parameters: [String: Any] = [
            "grant_type": "refresh_token",
            "refresh_token": (Auth.current?.refreshToken ?? "")
        ]
        
        Alamofire.request(ApiURL.refreshToken,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: self.header)

            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
        }

    }
    
    static func taskList(callback: @escaping ([String: TaskResponse]?) -> ()) {
        
        Loading.show()
        Alamofire.request(ApiURL.task,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: self.header)
            
            .responseJSON { response in
                callback(JSONDecoder.decode(data: response.data))
                Loading.dismiss()
        }
    }


}
