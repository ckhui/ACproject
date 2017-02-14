//
//  style.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/11/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation
import UIKit


/*
protocol LogoProtocol : class {

    func configureLogo(_ logo: UIImage?, size: CGSize?)
}

extension LogoProtocol where Self:UIViewController {
    func configureLogo(_ logo: UIImage?, size: CGSize?) {
    
        let logoImage = logo ?? UIImage(named: "next_logo")
        let size = size ?? CGSize(width: 40, height: 40)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = logoImage
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}


extension UIViewController : LogoProtocol{}

class NEXTViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLogo(nil, size: nil)
    }
}
 */


class NEXTViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureLogo(nil, size: nil)
    }
    
    func configureLogo(_ logo: UIImage?, size: CGSize?) {
        
        let logoImage = logo ?? UIImage(named: "next_logo")
        let size = size ?? CGSize(width: 40, height: 40)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        imageView.image = logoImage
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        navigationItem.titleView = imageView
    }
    
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    static let lightBlue = UIColor(hexString: "#5ac8faff") ?? UIColor.clear
    static let darkBlue = UIColor(hexString: "#056f9fff") ?? UIColor.clear
}

class Style {
    
    static let menuBarBGColor = UIColor.lightBlue
    static let menuBarTintColor = UIColor.white
    
    static let mainButtonColor = UIColor.lightBlue
    static let mainButtonTintColor = UIColor.white
    static let mainButtonBorderColor = UIColor.darkBlue
    
    static let disabledMainButtonColor = UIColor.lightBlue.withAlphaComponent(0.5)
    static let disabledMainButtonTintColor = UIColor.lightGray
    static let disabledMainButtonBorderColor = UIColor.darkBlue.withAlphaComponent(0.5)
    
    static let subButtonColor = UIColor.white
    static let subButtonTintColor = UIColor.lightBlue
    static let subButtonBorderColor = UIColor.lightBlue
    
    static let disabledSubButtonColor = UIColor.white
    static let disabledSubButtonTintColor = UIColor.lightGray
    static let disabledSubButtonBorderColor = UIColor.lightGray
    
    
    
    static let clockFormat = "hh:mm:ss"
    //"yyyy/MM/dd EEEE \nhh:mm:ss a \nzzzz"
    
}


extension UIViewController{
    
    func warningPopUp(withTitle title : String?, withMessage message : String?){
        let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        popUP.addAction(okButton)
        present(popUP, animated: true, completion: nil)
    }
    
    func setLogo() {
        let logoImage = UIImage(named: "next_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = logoImage
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    func setNaviBarHeight(height : CGFloat){
        
        guard let bounds = self.navigationController?.navigationBar.bounds
            else { return }
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
    }
    
    func initNaviBar(){
        setNaviBarHeight(height: 80)
        setLogo()
    }
}


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


