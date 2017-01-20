//
//  ACModeView.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/18/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit



class ACModeView: UIView {
    
    var view: UIView!
    
    var isEnable : Bool = true {
        didSet{
            if isEnable {
                self.view.alpha = 1.0
            }else{
                //self.view.backgroundColor = UIColor.blue
                self.view.alpha = 0.5
                
            }
        }
    }
    
    
     @IBOutlet weak var modeIamgeView: UIImageView!
     @IBOutlet weak var modeLabel: UILabel!
    
    //    @IBOutlet var modeDisplays: [ACModeView]! {
    //        didSet{
    //            for modeDisplay in modeDisplays {
    //                modeDisplay.mode = Aircond.Mode(rawValue: modeDisplay.tag) ?? .COLD
    //            }
    //        }
    //
    //    }
    
    var mode : Aircond.Mode = .COLD {
        didSet{
            displayMode()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        modeXibSetup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modeXibSetup()
    }
    
    func modeXibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
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
    
    func loadViewFromNib() -> UIView {
        
        //        let bundle = Bundle(for: type(of: self))
        //        let nib = UINib(nibName: "ACModeView", bundle: bundle)
        //        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        let view = Bundle.main.loadNibNamed("ACModeView", owner: self, options: nil)?.first as! UIView
        
        return view
    }
    
}

