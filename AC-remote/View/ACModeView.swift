//
//  ACModeView.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/18/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit



class ACModeView: UIView {
    

    var isEnable : Bool = true {
        didSet{
            if isEnable {
                self.alpha = 1.0
            }else{
                //self.view.backgroundColor = UIColor.blue
                self.alpha = 0.5
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
        
        
        //mode = Aircond.Mode(rawValue: modeHashValue) ?? .COLD
        
        var img : UIImage?
        var str : String
        switch mode {
        case .COLD:
            img = UIImage(named: "mode_cold")
            str = "COLD"
        case .DRY:
            img = UIImage(named: "mode_dry")
            str = "DRY"
        case .WET:
            img = UIImage(named: "mode_wet")
            str = "WET"
        }
        
        modeIamgeView.image = img
        modeLabel.text = str
    }
}

