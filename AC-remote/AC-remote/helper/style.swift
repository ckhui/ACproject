//
//  style.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/11/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation
import UIKit

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
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.image = logoImage
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
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
