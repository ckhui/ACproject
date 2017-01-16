//
//  CustomStyledButtom.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/12/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class CustomStyledButtom: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        self.YellowButtonStyle()
//    }
    
    override func awakeFromNib() {
        YellowButtonStyle()
    }
    
    override var isEnabled: Bool {
        didSet{
            isEnabled ? YellowButtonStyle() : disabledYellowButtonStyle()
        }
    }
}
