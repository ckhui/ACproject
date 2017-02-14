//
//  AircondBoard.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/17/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class AircondBoard: UIView {

    var view: UIView! {
        didSet{
           view.isOpaque = false
        }
    }
    
    
    var aircond = Aircond() {
        didSet{
            dump(aircond)
            showACStatus(aircond)
        }
    }
    var bgColor = UIColor.clear {
        didSet{
            self.view.backgroundColor = bgColor
        }
    }

    @IBOutlet weak var mode1: ACModeView!
    @IBOutlet weak var mode2: ACModeView!
    @IBOutlet weak var mode3: ACModeView!

    @IBOutlet var fanViews: [UIButton]!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        
        
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        
        //cal

        
//        let a = view.subviews.map { (subview) -> CGFloat in
//            return subview.frame.maxX
//        }
//        
//        let b = view.subviews.map { (subview) -> CGFloat in
//            return subview.frame.maxY
//        }
//        
//        
//                let scale = min(bounds.width / (a.max()! + 10) , bounds.height / (b.max()! + 10))
//        
////                let scale = min(bounds.width / view.frame.width , bounds.height / view.frame.height)
//        
//        view.transform = view.transform.scaledBy(x: scale, y: scale)
//        
//        view.transform = view.transform.translatedBy(x: (bounds.width - view.frame.width) / 2, y: (bounds.height - view.frame.height) / 2)
//        
//        view.translatesAutoresizingMaskIntoConstraints  = false
        
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        
        view.frame = bounds
//        print("bound")
//        dump(bounds)
//        
//        // Make the view stretch with containing view
//
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
  
        initValue()
        adjustFontSize()
        showACStatus(aircond)
    }
    
    func adjustFontSize(){
        
        
        mode1.layoutIfNeeded()
        mode2.layoutIfNeeded()
        mode3.layoutIfNeeded()
        
        let size1 = mode1.modeLabel.font.pointSize
        let size2 = mode2.modeLabel.font.pointSize
        let size3 = mode3.modeLabel.font.pointSize
        
        print("SIZE")
        print(size1 , size2 ,size3)
        
        let minSize = min(size1, size2 ,size3)
        
        let font = mode1.modeLabel.font.withSize(minSize)
        
        mode1.modeLabel.font = font
        mode2.modeLabel.font = font
        mode3.modeLabel.font = font
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
    

    func loadViewFromNib() -> UIView {
        
        //        let bundle = Bundle(for: type(of: self))
        //        let nib = UINib(nibName: "ACModeView", bundle: bundle)
        //        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        let view = Bundle.main.loadNibNamed("AircondBoard", owner: self, options: nil)?.first as! UIView
        
        return view
    }

}
