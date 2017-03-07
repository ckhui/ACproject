//
//  File.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/5/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation
import SwiftyJSON

class Aircond {
    
    var id : String  = "0"
    var status : Status  = .OFF
    var mode : Mode = .COLD
    var fanSpeed : FanSpeed = .MEDIUM
    var temperature : Int = 20
    var alias : String = ""
    var group : [String] = []
    
    enum Status : Int {
        case ON = 0
        case OFF
        case PENDING
    }
    
    enum Mode : Int{
        case DRY = 0
        case WET
        case COLD
    }
    
    enum FanSpeed : Int {
        case AUTO = 0
        case LOW
        case MEDIUM
        case HIGH
    }
    
    
    init() {}
    
    init (id : String, value : JSON){
        
        self.id = id
        
        if let _status = value["status"].string {
            switch(_status){
            case "ON" :
                status = .ON
            case "OFF" :
                status = .OFF
            default :
                status = .PENDING
            }
        }
    
        if let _mode = value["mode"].string {
            switch(_mode){
            case "DRY" :
                mode = .DRY
            case "WET" :
                mode = .WET
            case "COLD" :
                mode = .COLD
            default : break
            }
        }
        
        if let _fanSpeed = value["fan_speed"].string {
            switch(_fanSpeed){
            case "AUTO" :
                fanSpeed = .AUTO
            case "1" :
                fanSpeed = .LOW
            case "2" :
                fanSpeed = .MEDIUM
            case "3" :
                fanSpeed = .HIGH
            default : break
            }
        }
        
        if let _temperature = value["temperature"].int {
            temperature = _temperature
        }
        
        if let _alias = value["alias"].string {
            alias = _alias
        }
        
        
        let _group = value["aircond_group_id"].stringValue
        if _group != "" {
            group.append(_group)
        } else {
            group = ["Ungrouped"]
        }

    }
    
    
    func copy() -> Aircond {
        let copy = Aircond()
        copy.id = id
        copy.status = status
        copy.mode = mode
        copy.fanSpeed = fanSpeed
        copy.temperature = temperature
        copy.alias = alias
        
        return copy
    }
    
    
    func statusString() -> String{
        switch(status){
        case .ON :
            return "ON"
        case .OFF :
            return "OFF"
        case .PENDING:
            return "PENDING"
        }
    }
    
    func modeString() -> String{
        
        if status != .ON {
            return ""
        }
        
        switch(mode){
        case .DRY :
            return "DRY"
        case .WET :
            return "WET"
        case .COLD :
            return "COLD"
        }
    }

    
    func fanspeedString() -> String {
        if status != .ON || mode == .WET {
            return ""
        }
        
        switch(fanSpeed){
        case .AUTO :
            return "AUTO"
        case .LOW :
            return "1"
        case .MEDIUM :
            return "2"
        case .HIGH :
            return "3"
        }
    }
        
    func temperaturString() -> String {
        if status != .ON || mode == .DRY {
            return ""
        }
        
        return String(temperature)
    }
    
    

}
