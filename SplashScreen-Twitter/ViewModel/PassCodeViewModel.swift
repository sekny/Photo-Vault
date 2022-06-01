//
//  PassCodeViewModel.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 30/5/22.
//

import Foundation
import RxCocoa
import RealmSwift

class PassCodeViewModel {
    private(set) var totalBlockAsMin = 0
    private(set) var PINLength:Int = 4
    private let maxWrongPIN:Int = 3 //10
    private(set) var PINCode = ""
    private(set) var totalWrongPIN:Int = 0
    private(set) var totalWrongPassword:Int = 0
    let keyValues = ["1", "2", "3", "4", "5", "6", "7", "8", "9","a","0","x"]
    let user = BehaviorRelay<UserInfo?>(value: nil)
    var isDisabled: Bool {
        get {
            return user.value != nil && user.value!.isDisabled
        }
    }
    var isHasAccount: Bool {
        get {
            return user.value != nil
        }
    }
    
    var isValidPIN: Bool {
        get {
            return PINCode.count > PINLength && PINCode.suffix(4) == PINCode.prefix(4)
        }
    }
    
    func getData() {
        let realm = try! Realm()
        let entity = realm.objects(UserInfo.self).last
        self.user.accept(entity)
        totalBlockAsMin = entity?.lastBlockInMin ?? 0
    }
    
    func isValidUser(_ password: String) -> Bool {
        return user.value != nil && user.value?.password.decryptRNC(UserInfo.keyRNC) == password
    }
    
    func setDisable(_ isDisable: Bool) {
        let realm = try! Realm()
        let entity = realm.objects(UserInfo.self).last
        
        if entity != nil {
            try! realm.write {
                entity?.isDisabled = isDisable
            }
        }
    }
    
    func setPIN(_ pin: String) {
        if PINCode.count == PINLength*2 {return}
        
        PINCode += pin
    }
    
    func clearPIN() {
        PINCode = ""
    }
    
    func deleteLastPIN() {
        PINCode = String(PINCode.count == 0 ? "" : PINCode.dropLast())
    }
    
    
    func insert() {
        if PINCode.count < PINLength {
            return
        }
        
        let entity = UserInfo()
        entity.password = String(PINCode.prefix(PINLength)).encryptRNC(UserInfo.keyRNC)
        
        let realm = try! Realm()
        try! realm.write {
          realm.add(entity)
        }
    }
    
    func wrongPIN() {
//        totalWrongPIN += 1
//        
//        let realm = try! Realm()
//        let entity = realm.objects(UserInfo.self).last
//        
//        if entity != nil {
//            var totalDisableByToday = entity!.totalDisableByToday + 1
//            if entity?.lastBlockDate == nil || !Calendar.current.isDateInToday((entity?.lastBlockDate)!) {
//                totalDisableByToday = 1
//            }
//            
//  
//            try! realm.write {
//                entity?.lastBlockDate = Date.now
//                entity?.totalDisableByToday = totalDisableByToday
//            }
//        }
    }
    
    func wrongPassword() {
        totalWrongPassword += 1
        
        let realm = try! Realm()
        let entity = realm.objects(UserInfo.self).last
        
        if entity != nil {
            var totalDisableByToday = entity!.totalDisableByToday + 1
            var totalBlock = entity!.totalBlock
            var isDisable = entity!.isDisabled
            if entity?.lastBlockDate == nil || !Calendar.current.isDateInToday((entity?.lastBlockDate)!) {
                totalDisableByToday = 1
            }
            
            if totalWrongPassword % maxWrongPIN == 0 {
                isDisable = true
                totalBlock += 1
                
                if entity!.lastBlockInMin <= 0 || (entity!.lastBlockInMin > 0 && totalBlock < Int(maxWrongPIN / 2)) {
                    totalBlockAsMin = Int(totalDisableByToday / maxWrongPIN)
                } else {
                    totalBlockAsMin = entity!.lastBlockInMin * Int(totalDisableByToday / maxWrongPIN)
                }
            }
            
            try! realm.write {
                entity?.totalChangePassword += (totalWrongPassword % maxWrongPIN == 0 ? 1 : 0)
                entity?.lastBlockDate = Date.now
                entity?.totalDisableByToday = totalDisableByToday
                entity?.totalBlock = totalBlock
                entity?.isDisabled = isDisable
                entity?.lastBlockInMin = totalBlockAsMin > 0 ? totalBlockAsMin : entity!.lastBlockInMin
            }
        }
    }
    
    func reset() {
        let realm = try! Realm()
        let entity = realm.objects(UserInfo.self).last
        
        if entity != nil {
            try! realm.write {
                entity?.totalChangePassword = 0
                entity?.lastBlockDate = nil
                entity?.totalDisableByToday = 0
                entity?.totalBlock = 0
                entity?.isDisabled = false
                entity?.lastBlockInMin = 0
            }
        }
    }
}
