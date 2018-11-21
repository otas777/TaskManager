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
    
    static func write(callback: (Realm) -> ()) {
        guard let realm = try? Realm() else {
            return
        }
        
        try? realm.write {
            callback(realm)
        }
    }
    
    static func add(entity: Entity) {
        entity.update()
        self.write { (realm) in
            realm.add(entity)
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
