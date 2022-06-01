//
//  Document.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 25/5/22.
//

import RealmSwift
import Foundation

class Document : Object {
    static let keyRNC = "(d.0,c?!9@PAz)_P@$$"
    
    @objc dynamic var id: UUID = UUID.init()
    @objc dynamic var file: NSData? = nil
    @objc dynamic var thumnail: NSData? = nil
    @objc dynamic var isImage: Bool = true
    @objc dynamic var AddedDate: Date = Date.now
    @objc dynamic var isDeleted: Bool = false
    @objc dynamic var deletedDate: Date? = nil
    @objc dynamic var isFavorite: Bool = false
}

class UserInfo : Object {
    static let keyRNC = "(:.,?P!9@PAz)_P@$$"
    
    @objc dynamic var password: String = ""
    @objc dynamic var totalBlock: Int = 0
    @objc dynamic var totalLogin: Int = 0
    @objc dynamic var totalChangePassword: Int = 0
    @objc dynamic var lastBlockDate: Date? = nil
    @objc dynamic var lastBlockInMin: Int = 0
    @objc dynamic var totalDisableByToday: Int = 0 //reset everyday
    @objc dynamic var isDisabled: Bool = false
}
