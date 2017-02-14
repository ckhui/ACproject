//
//  AircondBoardCollectionViewCell.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/7/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class AircondBoardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mode1: ACModeView!
    @IBOutlet weak var mode2: ACModeView!
    @IBOutlet weak var mode3: ACModeView!
    
    @IBOutlet var fanViews: [UIButton]!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    static let cellIdentifier = "AircondBoardCell"
    static let cellNib = UINib(nibName: "AircondBoardCollectionViewCell", bundle: Bundle.main)
    
    
    var aircond = Aircond()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initValue()
    }
    
    func initValue(){
        mode1.mode = .COLD
        mode2.mode = .DRY
        mode3.mode = .WET
        
        mode1.isEnable = false
        mode2.isEnable = false
        mode3.isEnable = false
    }
    
    func showACStatus(_ ac : Aircond) {
        aircond = ac
        showMode()
        showFanspeed()
        temperatureLabel.text = ac.temperaturString()
    }
    
    func showMode() {
        
        offMode()
        
        if aircond.status != .ON {
            return
        }
        
        switch(aircond.mode){
        case .DRY :
            mode2.isEnable = true
        case .WET :
            mode3.isEnable = true
        case .COLD :
            mode1.isEnable = true
        }
    }
    
    func offMode() {
        mode1.isEnable = false
        mode2.isEnable = false
        mode3.isEnable = false
    }
    
    func showFanspeed() {
        if aircond.status != .ON || aircond.mode == .WET {
            fanViews.forEach{ button in
                button.isEnabled = false
            }
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


}
