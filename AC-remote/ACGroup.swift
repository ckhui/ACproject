//
//  File.swift
//  AC-remote
//
//  Created by CKH on 06/03/2017.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation


class ACGroup {
    var id : String = "None"
    var name : String = "Untitled Group"
    var airconds : [Aircond] = []
    
    init(id : String, name : String?) {
        self.id = id
        self.name = name ?? "Untitled Group"
    }
    
    func getOnOffNumber() -> String {
        var onCount = 0
        airconds.forEach { (ac) in
            if ac.status == .ON {
                onCount += 1
            }
        }
        
        return "\(onCount) / \(airconds.count)"
    }
    
}
