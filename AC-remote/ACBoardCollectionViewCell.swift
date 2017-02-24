//
//  ACBoardCollectionViewCell.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/10/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class ACBoardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel : UILabel!
    
    @IBOutlet weak var mode: ACModeView!

    @IBOutlet weak var fanLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tempClabel: UILabel!

    @IBOutlet weak var onOffButton: UIImageView!{
        didSet{
            onOffButton.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleOnOffButtonTapped))
            onOffButton.addGestureRecognizer(tap)
        }
    }
    
    var aircond = Aircond()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func handleOnOffButtonTapped(){
        aircond.status = aircond.status == .ON  ? .OFF : .ON
        //TODO : sendRequest
        showACStatus(aircond)
    }
    
    func showACStatus(_ ac : Aircond) {
        aircond = ac
        nameLabel.text = aircond.alias
        
        showOnOff()
        showMode()
        showFanspeed()
        showTemperature()
    }
    
    func showOnOff(){
        if aircond.status == .ON {
            onOffButton.image = UIImage(named: "power-on")
        } else {
            onOffButton.image = UIImage(named: "power-off")
        }
    }
    
    func showMode() {
        mode.isEnable = (aircond.status == .ON) ? true : false
        mode.mode = aircond.mode
    }
    
    func showFanspeed() {
        if aircond.status != .ON || aircond.mode == .WET
        {
            fanLabel.text = ""
            return
        }
        
        let fanHashValue = aircond.fanSpeed.hashValue
        if fanHashValue == 0 {
            fanLabel.text = "AUTO"

        } else {
            fanLabel.text = String(fanHashValue)
            }
        }

    func showTemperature(){
        if aircond.temperaturString() == "" {
            temperatureLabel.text = ""
            tempClabel.isHidden = true
        }
        else{
            temperatureLabel.text = aircond.temperaturString()
            tempClabel.isHidden = false
        }
    }
}
