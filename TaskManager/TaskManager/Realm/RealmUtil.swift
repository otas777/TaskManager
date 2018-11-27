//
//  RealmUtil.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/21.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUtil  {
    
    /// テーブルから全レコードの取得
    ///
    /// - Returns: 取得結果
    static func findAll<T: Object>() -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
    
    /// 条件に合致するレコードの取得
    ///
    /// - Parameters:
    ///   - format: 検索条件のフォーマット
    ///   - args: フォーマットに置き換える値
    /// - Returns: 検索結果
    static func find<T: Object>(format: String, args: Any...) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self).filter(format, args)
    }
    
    /// DBへの書き込みトランザクションの取得
    ///
    /// - Parameter callback: トランザクション
    static func write(callback: (Realm) -> ()) {
        let realm = try! Realm()
        try! realm.write {
            callback(realm)
        }
    }
    
    /// DBへの追加・更新
    ///
    /// - Parameter obj: 追加・更新の対象
    static func add(obj: Object) {
        self.write { (realm) in
            realm.add(obj, update: true)
        }
    }
    
    /// DBへの追加・更新（リスト）
    ///
    /// - Parameter list:  追加・更新の対象
    static func add(list: [Object]) {
        self.write { (realm) in
            for obj in list {
                realm.add(obj, update: true)
            }
        }
    }
    
    /// DBから削除
    ///
    /// - Parameter obj: 削除対象
    static func delete(obj: Object) {
        self.write { (realm) in
            realm.delete(obj)
        }
    }
    
    /// DBから全レコードの削除
    ///
    /// - Parameter type: 削除対象
    static func deleteAll(type: Object.Type) {
        self.write { (realm) in
            realm.delete(realm.objects(type))
        }
    }
}
