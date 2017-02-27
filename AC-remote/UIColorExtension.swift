//
//  UIColorExtension.swift
//  AC-remote
//
//  Created by CKH on 27/02/2017.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation
import UIKit

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
    
    static let backgroundColor = UIColor(hexString: "#073642ff") ?? UIColor.clear
    
    static let customeGreen = UIColor(hexString: "#2aa198ff") ?? UIColor.clear
    
    static let customeYellow = UIColor(hexString: "#edb83dff") ?? UIColor.clear
    
    
}
