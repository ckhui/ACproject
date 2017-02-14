//
//  RemoteViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/7/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class RemoteViewController: UIViewController {

    
    //@IBOutlet weak var nameLabel : UILabel!
    
    @IBOutlet weak var mode1: ACModeView!
    @IBOutlet weak var mode2: ACModeView!
    @IBOutlet weak var mode3: ACModeView!
    
    @IBOutlet var fanViews: [UIButton]!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var aircond = Aircond()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initModeBoard()
        
        showACStatus()
    }
    
    func initModeBoard(){
        mode1.mode = .COLD
        mode2.mode = .DRY
        mode3.mode = .WET
        
        mode1.isEnable = false
        mode2.isEnable = false
        mode3.isEnable = false
    }
    
    func showACStatus() {

        title = aircond.alias
        showMode()
        showFanspeed()
        showTemperature()
    }
    
    func showMode() {
        mode1.isEnable = false
        mode2.isEnable = false
        mode3.isEnable = false
        if aircond.status != .ON {
            return
        }
        
        
        switch aircond.mode {
        case .COLD: mode1.isEnable = true
        case .DRY : mode2.isEnable = true
        case .WET : mode3.isEnable = true
        }
    }
    
    
    func showFanspeed() {
        if aircond.status != .ON || aircond.mode == .WET {
            fanViews.forEach{ button in
                button.isEnabled = false
            }
            return
        }
        
        let fanHashValue = aircond.fanSpeed.hashValue
        if fanHashValue == 0 {
            fanViews.forEach{ button in
                button.isEnabled = (button.tag == 3) ?true : false
            }
        } else {
            fanViews.forEach{ button in
                button.isEnabled = (button.tag < fanHashValue) ? true : false
            }
        }
    }
    
    func showTemperature(){
        temperatureLabel.text = aircond.temperaturString()
    }
    
    
    //MARK : buttons
    let maxTemperature = 30
    let minTemperature = 16

    @IBAction func plusButtonPressed(_ sender: Any) {
        if aircond.status != .ON || aircond.mode == .DRY {
        
        aircond.temperature = min(aircond.temperature + 1, maxTemperature)
        }
        
        showTemperature()
        
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        if aircond.status != .ON || aircond.mode == .DRY {
        aircond.temperature = max(aircond.temperature - 1, minTemperature)
        }
        
        showTemperature()
    }
    
    @IBAction func fanButtonPressed(_ sender: Any) {
        var newFanHashValue = (aircond.fanSpeed.hashValue + 1) % 4
        
        if (newFanHashValue == 0 && aircond.mode == .DRY){
            newFanHashValue = 1
        }
        aircond.fanSpeed = Aircond.FanSpeed(rawValue: newFanHashValue) ?? Aircond.FanSpeed.AUTO
        
        showFanspeed()
    }
    
    @IBAction func modeButtonPressed(_ sender: Any) {
        let newModeHashValue = (aircond.mode.hashValue + 1) % 3
 
        aircond.mode = Aircond.Mode(rawValue: newModeHashValue) ?? Aircond.Mode.COLD
        
        showACStatus()
        
    }
    

    @IBAction func onOffButtonPressed(_ sender: Any) {
        
        switch aircond.status {
        case .ON:
            aircond.status = .OFF
        case .OFF:
            aircond.status = .ON
        default:
            warningPopUp(withTitle: "Aircond", withMessage: "PENDING")
        }

        showACStatus()
    }
    
    
}

