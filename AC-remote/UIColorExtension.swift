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
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    static let lightBlue = UIColor(hexString: "#5ac8faff") ?? UIColor.clear
    static let darkBlue = UIColor(hexString: "#056f9fff") ?? UIColor.clear
    
    static let backgroundColor = UIColor(hexString: "#073642ff") ?? UIColor.clear
    
    static let customeGreen = UIColor(hexString: "#2aa198ff") ?? UIColor.clear
    
    static let customeYellow = UIColor(hexString: "#edb83dff") ?? UIColor.clear
    
    
    static let hotRed = UIColor(hexString: "#4dc7fdff") ?? UIColor.red
    
    static let coldBlue = UIColor(hexString: "#cd1e10ff") ?? UIColor.blue
    
    
    
    private static let maxColor = UIColor.hotRed.cgColor
    private static let minColor = UIColor.coldBlue.cgColor
    
    private static let minR = UIColor.minColor.components?[0] ?? 0.0
    private static let minG = UIColor.minColor.components?[1] ?? 0.0
    private static let minB = UIColor.minColor.components?[2] ?? 0.0
    
    private static var deltaR : CGFloat {
        if let maxR = UIColor.maxColor.components?[0],
            let minR = UIColor.minColor.components?[0] {
            return (maxR - minR) / 14.0
        }
        else {
            return 0
        }
    }
    
    private static var deltaG : CGFloat {
        if let maxG = UIColor.maxColor.components?[1],
            let minG = UIColor.minColor.components?[1] {
            return (maxG - minG) / 14.0
        }
        else {
            return 0
        }
    }
    
    private static var deltaB : CGFloat {
        if let maxB = UIColor.maxColor.components?[2],
            let minB = UIColor.minColor.components?[2] {
            return (maxB - minB) / 14.0
        }
        else {
            return 0
        }
    }
    static func coldWarmColor(temp : Int) -> UIColor {
        let changeTemp : CGFloat = 30 - CGFloat(temp)
        return UIColor.init(red: minR + deltaR * changeTemp, green: minG + deltaG * changeTemp, blue: minB + deltaB * changeTemp, alpha: 1)
    }
}

