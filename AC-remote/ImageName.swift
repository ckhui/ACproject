//
//  ImageName.swift
//  AC-remote
//
//  Created by CKH on 23/02/2017.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation

class ImageName {
    static func getModeImageName(mode: ModeButton, status : Status) -> String {
        if status == .none {
            return mode.rawValue
        }
        
        return "mode-\(mode.rawValue)-\(status.rawValue)"
    }
    
    static func getSpeedImageName(speed : SpeedType, status : Status) -> String {
        if status == .none {
            return "speed-\(speed.rawValue)"
        }
        
        return "speed-\(speed.rawValue)-\(status.rawValue)"
    }
    
    static func getTemperatureImageName(temperatue : Int) -> String {
        return "temp-\(temperatue)"
    }
    
    enum ModeButton : String{
        case cold
        case dry
        case wet
    }
    
    enum Status : String {
        case on
        case off
        case none
    }
    
    enum SpeedType : String {
        case one = "1"
        case two = "2"
        case three = "3"
        case auto
    }
}
