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
    
    @IBInspectable var mainStyle : Bool = true
    
    override func awakeFromNib() {
        
        layer.cornerRadius = min(frame.height, frame.width) / 4
        layer.borderWidth = 2
        
        if mainStyle {
            mainButtonStyle()
        }else{
            subButtonStyle()
        }
    }
    
    override var isEnabled: Bool {
        didSet{
            if mainStyle {
                isEnabled ? mainButtonStyle() : disabledMainButtonStyle()
            }else{
                isEnabled ? subButtonStyle() : disabledSubButtonStyle()
            }
        }
    }
    
    func mainButtonStyle() {
        self.backgroundColor = Style.mainButtonColor
        self.tintColor = Style.mainButtonTintColor
        layer.borderColor = Style.mainButtonBorderColor.cgColor
    }
    
    func disabledMainButtonStyle(){
        self.backgroundColor = Style.disabledMainButtonColor
        self.tintColor = Style.disabledMainButtonTintColor
        layer.borderColor = Style.disabledMainButtonBorderColor.cgColor
    }
    
    func subButtonStyle() {
        self.backgroundColor = Style.subButtonColor
        self.tintColor = Style.subButtonTintColor
        layer.borderColor = Style.subButtonBorderColor.cgColor
    }
    
    func disabledSubButtonStyle(){
        self.backgroundColor = Style.disabledSubButtonColor
        self.tintColor = Style.disabledSubButtonTintColor
        layer.borderColor = Style.disabledSubButtonBorderColor.cgColor
    }
    
}
