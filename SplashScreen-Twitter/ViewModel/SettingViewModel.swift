//
//  SettingViewModel.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 31/5/22.
//

import Foundation

class SettingViewModel {
    let items: [String : [SettingModel]] = [
        "General": [
            SettingModel(type: .ChangePasscode, icon: "lock.shield", title: "Change Passcode", rightIcon: ""),
            SettingModel(type: .About, icon: "exclamationmark.circle", title: "About", rightIcon: "")
        ]
        
    ]
}
