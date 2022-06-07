//
//  SettingModel.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 2/6/22.
//

import Foundation

class SettingModel {
    private(set) var icon: String = ""
    private(set) var title: String = ""
    private(set) var rightIcon: String = ""
    private(set) var type: SettingType
    
    init(type: SettingType, icon: String = "", title: String = "", rightIcon: String = "") {
        self.type = type
        self.icon = icon
        self.title = title
        self.rightIcon = rightIcon
    }
    
    init(_ type: SettingType, _ title: String) {
        self.type = type
        self.title = title
    }
}
