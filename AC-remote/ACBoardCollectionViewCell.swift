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

    @IBOutlet var fanViews: [UIButton]!
    
    @IBOutlet weak var temperatureLabel: UILabel!

    var aircond = Aircond()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    func showACStatus(_ ac : Aircond) {
        aircond = ac
        nameLabel.text = aircond.alias
        showMode()
        showFanspeed()
        temperatureLabel.text = ac.temperaturString()
    }
    
    func showMode() {
        mode.isEnable = (aircond.status == .ON) ? true : false
        mode.mode = aircond.mode
    }
    
    
    func showFanspeed() {
        if aircond.status != .ON || aircond.mode == .WET {
            fanViews.forEach{ button in
                button.isHidden = true
            }
            return
        }
        
        let fanHashValue = aircond.fanSpeed.hashValue
        if fanHashValue == 0 {
            fanViews.forEach{ button in
                button.isHidden = (button.tag == 3) ?false : true
            }
        } else {
            fanViews.forEach{ button in
                button.isHidden = (button.tag < fanHashValue) ? false : true
            }
        }
        
    }

}
