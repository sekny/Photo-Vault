//
//  Document.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 25/5/22.
//

import RealmSwift
import Foundation

class Document : Object {
    @objc dynamic var id: UUID = UUID.init()
    @objc dynamic var file: NSData? = nil
//    @objc dynamic var size: CGFloat = 0
    @objc dynamic var isImage: Bool = true
    @objc dynamic var AddedDate: Date = Date.now
    
    
//    func get() {
//        let realm = try! Realm()
//        let entities = realm.objects(Document.self)
//        print(entities)
//    }
//    
//    func set(object: Document) {
//        let realm = try! Realm()
//        
//        realm.beginWrite()
//        realm.add(object)
//        try! realm.commitWrite()
//    }
}
