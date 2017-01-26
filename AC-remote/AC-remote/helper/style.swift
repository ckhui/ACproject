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
        navigationItem.titleView = imageView
    }
}

class Style {
    
    static let menuBarBGColor = UIColor.black
    static let menuBarTintColor = UIColor.white
    static let buttonColor = UIColor.yellow
    static let buttonTintColor = UIColor.black
    static let disabledButtonColor = UIColor.yellow.withAlphaComponent(0.5)
    static let disabledButtonTintColor = UIColor.lightGray
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


extension UIButton {
    func YellowButtonStyle() {
        self.backgroundColor = Style.buttonColor
        self.tintColor = Style.buttonTintColor
    }
    
    func disabledYellowButtonStyle(){
        self.backgroundColor = Style.disabledButtonColor
        self.tintColor = Style.disabledButtonTintColor
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


