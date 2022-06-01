//
//  Date.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 26/5/22.
//

import Foundation
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
