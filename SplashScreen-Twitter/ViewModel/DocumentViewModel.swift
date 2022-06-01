//
//  DocumentViewModel.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 30/5/22.
//

import Foundation
import RxCocoa
import RealmSwift

class DocumentViewModel {
    let items = BehaviorRelay<[Document]>(value: [Document]())
    let deleteItems = BehaviorRelay<[Document]>(value: [Document]())
    
    func getData() {
        let realm = try! Realm()
        let entities = realm.objects(Document.self)
        
        self.items.accept(Array(entities).filter{ !$0.isDeleted})
        self.deleteItems.accept(Array(entities).filter{ $0.isDeleted})
        print("Total Images: \(items.value.count)")
        print("Total Delete Images: \(deleteItems.value.count)")
        DataNotifier.shared.disableReload()
    }
    
    func upateToDeleteObjects(_ ids: [UUID]) {
        bulkUpdateBooleanValueByKey(ids: ids, key: "isDeleted", value: true)
    }
    
    func addToFavorites(_ ids: [UUID]) {
        bulkUpdateBooleanValueByKey(ids: ids, key: "isFavorite", value: true)
    }
    
    private func bulkUpdateBooleanValueByKey(ids: [UUID], key: String, value: Bool) {
        let realm = try! Realm()
        try! realm.write {
            let documents = realm.objects(Document.self).filter("id IN %@", ids)
            documents.setValue(value, forKey: key)
        }
        DataNotifier.shared.enableReload()
    }
    
    func forceDeleteObjects(_ idToDeletes: [UUID]) {
        let realm = try! Realm()
        try! realm.write({
            let objectsToDeletes = realm.objects(Document.self).filter("id IN %@", idToDeletes)
            realm.delete(objectsToDeletes)
        });
        DataNotifier.shared.enableReload()
    }
    
    func insertObject(_ entity: Document) {
        let realm = try! Realm()
        try! realm.write {
          realm.add(entity)
        }
        DataNotifier.shared.enableReload()
    }
}
