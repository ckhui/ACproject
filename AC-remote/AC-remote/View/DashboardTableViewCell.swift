//
//  DashboardTableViewCell.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/5/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var fanLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var aliasLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initLabels()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }


    
    func initLabels(){
        idLabel.text = ""
        statusLabel.text = ""
        modeLabel.text = ""
        fanLabel.text = ""
        temperatureLabel.text = ""
        aliasLabel.text = ""
    }
    
    
    func displayDetails(aircond : Aircond){
        initLabels()
        
        idLabel.text = aircond.id
        
        statusLabel.text = aircond.statusString()
        modeLabel.text = aircond.modeString()
        fanLabel.text = aircond.fanspeedString()
        temperatureLabel.text = aircond.temperaturString()
        
        aliasLabel.text = aircond.alias
        
        
        
        
        
//        switch(aircond.status){
//        case .ON :
//            statusLabel.text = "ON"
//        case .OFF :
//            statusLabel.text = "OFF"
//            return
//        case .PENDING:
//            statusLabel.text = "PENDING"
//            return
//        }
//    
//        displayModeSpeedTemperature(aircond: aircond)
        
    }
    
    func displayModeSpeedTemperature(aircond : Aircond){
        switch(aircond.mode){
        case .DRY :
            modeLabel.text = "DRY"
            displayFanSpeed(speed: aircond.fanSpeed)
        case .WET :
            modeLabel.text = "WET"
            temperatureLabel.text = String(aircond.temperature)
        case .COLD :
            modeLabel.text = "COLD"
            displayFanSpeed(speed: aircond.fanSpeed)
            temperatureLabel.text = String(aircond.temperature)
        }
    }
    
    func displayFanSpeed(speed : Aircond.FanSpeed){
        switch(speed){
        case .AUTO :
            fanLabel.text = "AUTO"
        case .LOW :
            fanLabel.text = "LOW"
        case .MEDIUM :
            fanLabel.text = "MEDIUM"
        case .HIGH :
            fanLabel.text = "HIGH"
        }
    }

}
