//
//  ACModeView.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/18/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit



class ACModeView: UIView {
    

    var isEnable : Bool = true{
        didSet{
            if isEnable {
                modeIamgeView.alpha = 1.0
                modeLabel.alpha = 1.0
            }else{
                modeIamgeView.alpha = 0.5
                modeLabel.alpha = 0.5
            }
        }
    }
    
    
    
     @IBOutlet weak var modeIamgeView: UIImageView!
     @IBOutlet weak var modeLabel: UILabel!
    
    
    var mode : Aircond.Mode = .COLD {
        didSet{
            displayMode()
        }
    }
    
    func displayMode(){
        var img : UIImage?
        var str : String
        switch mode {
        case .COLD:
            img = UIImage(named: ImageName.getModeImageName(mode: .cold, status: .none))
            str = "COLD"
        case .DRY:
            img = UIImage(named: ImageName.getModeImageName(mode: .dry, status: .none))
            str = "DRY"
        case .WET:
            img = UIImage(named: ImageName.getModeImageName(mode: .wet, status: .none))
            str = "WET"
        }
        
        modeIamgeView.image = img
        modeLabel.text = str
    }
}

