//
//  DataNotifier.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 30/5/22.
//

import Foundation
import RxCocoa

class DataNotifier {
    static let shared = DataNotifier()
    var isReloadable = BehaviorRelay<Bool>(value: true)
    
    func enableReload() {
        self.isReloadable.accept(true)
    }
    
    func disableReload() {
        self.isReloadable.accept(false)
    }
}
