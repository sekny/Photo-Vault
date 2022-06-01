//
//  StringExtension.swift
//  SplashScreen-Twitter
//
//  Created by YIM SEKNY on 30/5/22.
//

import Foundation
import RNCryptor

extension String {
    func encryptRNC(_ secretKey: String) -> String {
            let data: Data = self.data(using: .utf8)!
            let encryptedData = RNCryptor.encrypt(data: data, withPassword: secretKey)
            let encryptedString : String = encryptedData.base64EncodedString() // getting base64encoded string of encrypted data.
            return encryptedString
    }

    func decryptRNC(_ secretKey: String) -> String {
            do  {
                let data: Data = Data(base64Encoded: self)! // Just get data from encrypted base64Encoded string.
                let decryptedData = try RNCryptor.decrypt(data: data, withPassword: secretKey)
                let decryptedString = String(data: decryptedData, encoding: .utf8) // Getting original string, using same .utf8 encoding option,which we used for encryption.
                return decryptedString ?? ""
            }
            catch {
                return "FAILED"
            }
    }
}
