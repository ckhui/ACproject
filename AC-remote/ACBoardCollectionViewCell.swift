//
//  ACBoardCollectionViewCell.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/10/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class ACBoardCollectionViewCell: UICollectionViewCell {

    var delegate : ACBoardCellDelegate?
    
    @IBOutlet weak var nameLabel : UILabel!
    
    @IBOutlet weak var modeView: ACModeView!

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
        
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.black.cgColor
        //layer.backgroundColor = UIColor.lightGray.cgColor
        
    }

    
    func handleOnOffButtonTapped(){
        let ac = aircond.copy()
        ac.status = ac.status == .ON  ? .OFF : .ON
        delegate?.ACBoardOnOffBtnPressed(aircond: ac)
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
            showInfo(true)
        } else {
            onOffButton.image = UIImage(named: "power-off")
            showInfo(false)
        }
    }
    
    func showMode() {
        modeView.mode = aircond.mode
    }
    
    func showFanspeed() {
        if aircond.mode == .WET
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
        if aircond.mode == .DRY {
            temperatureLabel.text = ""
            tempClabel.isHidden = true
        }
        else{
            temperatureLabel.text = "\(aircond.temperature)"
            tempClabel.isHidden = false
        }
    }
    
    func showInfo(_ yes : Bool) {
        if yes {
            modeView.isEnable = true
            fanLabel.isEnabled = true
            temperatureLabel.isEnabled = true
            tempClabel.isEnabled = true
        }else{
            modeView.isEnable = false
            fanLabel.isEnabled = false
            temperatureLabel.isEnabled = false
            tempClabel.isEnabled = false
        }
    }
}

protocol ACBoardCellDelegate {
    func ACBoardOnOffBtnPressed(aircond : Aircond)
}
