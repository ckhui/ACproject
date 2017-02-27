//
//  UserDeafultAndNotification.swift
//  AC-remote
//
//  Created by CKH on 27/02/2017.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation

extension UserDefaults {
    static func setDomain(url : String){
        UserDefaults.standard.setValue(url, forKey: "domain")
        UserDefaults.standard.synchronize()
    }
    
    static func getDomain() -> String{
        return UserDefaults.standard.string(forKey: "domain") ?? ""
    }
    
    static func setToken(token : String){
        UserDefaults.standard.setValue(token, forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
    static func getToken() -> String {
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    static func setName(name : String){
        UserDefaults.standard.setValue(name, forKey: "name")
        UserDefaults.standard.synchronize()
    }
    
    static func getName() -> String {
        return UserDefaults.standard.string(forKey: "name") ?? ""
    }
}


extension NotificationCenter {
    static func appSignIn(){
        let AuthSuccessNotification = Notification (name: Notification.Name(rawValue: "AuthSuccessNotification"), object: nil, userInfo: nil)
        self.default.post(AuthSuccessNotification)
    }
    
    static func appSignOut(){
        UserDefaults.setName(name: "")
        UserDefaults.setToken(token: "")
        
        let UserLogoutNotification = Notification (name: Notification.Name(rawValue: "UserLogoutNotification"), object: nil, userInfo: nil)
        self.default.post(UserLogoutNotification)
    }
}
