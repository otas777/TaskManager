//
//  Extensions.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/19.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// StoryboardからViewControllerを取得
    ///
    /// - Parameter storyboard: 対象のStoryboard
    /// - Returns: viewController
    static func instantiate(storyboard: UIStoryboard?) -> UIViewController? {
        let name = String(describing: self)
        return storyboard?.instantiateViewController(withIdentifier: name)
    }
}

extension JSONDecoder {

    /// デコード処理
    ///
    /// - Parameter data: デコードデータ
    /// - Returns: デコード結果
    static func decode<T: Decodable>(data: Data?) -> T? {
        guard let data = data else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error {
            print(error)
            return nil
        }
    }
}
