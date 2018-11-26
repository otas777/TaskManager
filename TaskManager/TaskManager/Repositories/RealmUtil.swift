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
    
    static func findAll<T: Entity>() -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self)
    }
    
    static func find<T: Entity>(format: String, args: Any...) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(T.self).filter(format, args)
    }
    
    static func write(callback: (Realm) -> ()) {
        let realm = try! Realm()
        try! realm.write {
            callback(realm)
        }
    }
    
    static func add(entity: Entity) {
        self.write { (realm) in
            entity.update()
            realm.add(entity, update: true)
        }
    }
    
    static func add(list: [Entity]) {
        self.write { (realm) in
            for entity in list {
                entity.update()
                realm.add(entity, update: true)
            }
        }
    }
    
    static func delete(entity: Entity) {
        self.write { (realm) in
            realm.delete(entity)
        }
    }
    
    static func deleteAll(type: Entity.Type) {
        self.write { (realm) in
            realm.delete(realm.objects(type))
        }
    }
}


extension Results {
    
}
