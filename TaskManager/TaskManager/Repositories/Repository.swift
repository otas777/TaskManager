//
//  Repository.swift
//  TaskManager
//
//  Created by 太田聖治 on 2018/11/20.
//  Copyright © 2018年 太田聖治. All rights reserved.
//

import Foundation
import RealmSwift

protocol Repository {
    associatedtype EntityType: Entity
}

extension Repository {
    
    func write(callback: (Realm) -> ()) {
        guard let realm = try? Realm() else {
            return
        }
        
        try? realm.write {
            callback(realm)
        }
    }

    func add(entity: EntityType) {
        guard let realm = try? Realm() else {
            return
        }
        
        entity.update()
        try? realm.write {
            realm.add(entity)
        }
    }
    
    func delete(entity: EntityType) {
        guard let realm = try? Realm() else {
            return
        }
        
        try? realm.write {
            realm.delete(entity)
        }
    }
    
    static func deleteAll() {
        guard let realm = try? Realm() else {
            return
        }
        
        try? realm.write {
            realm.delete(realm.objects(EntityType.self))
        }
    }

}
