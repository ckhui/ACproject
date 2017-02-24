//
//  RemotePageViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/21/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class RemotePageViewController: UIViewController {
    
    var selectedAircond = Aircond()
    
    
    @IBOutlet weak var onOffButton: UIImageView! {
        didSet{
            onOffButton.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(hanndleOnOffButtonTapped))
            onOffButton.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBOutlet weak var modeControl: ImageSegmentedControl! {
        didSet{
            modeControl.imageNames = [ImageName.getModeImageName(mode: .dry, status: .off),
                                      ImageName.getModeImageName(mode: .wet, status: .off),
                                      ImageName.getModeImageName(mode: .cold, status: .off)]
            
            modeControl.selectedImageNames = [ImageName.getModeImageName(mode: .dry, status: .on),
                                              ImageName.getModeImageName(mode: .wet, status: .on),
                                              ImageName.getModeImageName(mode: .cold, status: .on)]
            modeControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var fanControl: ImageSegmentedControl! {
        didSet{
            fanControl.imageNames = [ImageName.getSpeedImageName(speed: .one, status: .off),
                                     ImageName.getSpeedImageName(speed: .two, status: .off),
                                     ImageName.getSpeedImageName(speed: .three, status: .off),
                                     ImageName.getSpeedImageName(speed: .auto, status: .off)]
            
            fanControl.selectedImageNames = [ImageName.getSpeedImageName(speed: .one, status: .on),
                                             ImageName.getSpeedImageName(speed: .two, status: .on),
                                             ImageName.getSpeedImageName(speed: .three, status: .on),
                                             ImageName.getSpeedImageName(speed: .auto, status: .on)]
            
            fanControl.addTarget(self, action: #selector(fanChanged), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var temperatureSlider: UISlider!{
        didSet{
            temperatureSlider.addTarget(self, action: #selector(temperatureSliderChanged(_:)), for: .valueChanged)
        }
    }
    
    var temperatureImageView = UIImageView(frame: CGRect.zero) {
        didSet{
            temperatureImageView.contentMode = .scaleAspectFit
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTemperatureLabel()
        showAircondValue()
        
    }
    
    func setupTemperatureLabel(){
        temperatureSlider.addSubview(temperatureImageView)
        
        let tempLabelHeight : CGFloat = 40.0
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: tempLabelHeight * 1.5, height: tempLabelHeight))
        let center = CGPoint(x: temperatureSlider.thumbCenterX, y: temperatureSlider.frame.height + (tempLabelHeight / 2))
        temperatureImageView.frame = rect
        temperatureImageView.center = center
    }
    
    
    func hanndleOnOffButtonTapped(){
        //setTemperatureLabel(at: temperatureSlider.thumbCenterX, withTemperature: 18)
        if selectedAircond.status == .ON {
            onOffButton.image = UIImage(named: "power-on")
            selectedAircond.status = .OFF
        } else {
            onOffButton.image = UIImage(named: "power-off")
            selectedAircond.status = .ON
        }
    }
    
    func temperatureSliderChanged(_ slider : UISlider){
        
        //print(slider.value)
        let temp = 16 + Int(round(slider.value * 14))
        setTemperatureLabel(at: slider.thumbCenterX, withTemperature: temp)
        
    }
    
    func setTemperatureLabel(at pointX : CGFloat,withTemperature temperature : Int) {
        let image = UIImage(named: ImageName.getTemperatureImageName(temperatue: temperature))
        temperatureImageView.image = image
        
        temperatureImageView.center.x = pointX
    }
    
    func showAircondValue() {
        showStatus()
        showMode()
        showFanspeed()
        showTemperature()
    }
    
    func showStatus(){
        if selectedAircond.status == .ON {
            onOffButton.image = UIImage(named: "power-on")
            statusLabel.text = "\(selectedAircond.alias) is ON"
            modeControl.isEnabled = true
            fanControl .isEnabled = true
        } else {
            onOffButton.image = UIImage(named: "power-off")
            statusLabel.text = "\(selectedAircond.alias) is OFF"
            modeControl.isEnabled = false
            fanControl .isEnabled = false
        }
    }
    
    
    func showMode() {
        if selectedAircond.status == .ON {
            let modeHash = selectedAircond.mode.hashValue
            modeControl.selectedIndex = modeHash
        }
        else{
            modeControl.selectedIndex = -1
        }
        
        if selectedAircond.mode == .WET {
            fanControl.isEnabled = false
            fanControl.deselectIndex()
        }else{
            fanControl.isEnabled = true
            fanControl.displayNewSelectedIndex()
        }
        
        if selectedAircond.mode == .DRY {
            temperatureSlider.isEnabled = false
            temperatureImageView.isHidden = true
        }else{
            temperatureSlider.isEnabled = true
            temperatureImageView.isHidden = false
        }
    }
    
    
    func showFanspeed() {
        if selectedAircond.status != .ON || selectedAircond.mode == .WET {
            fanControl.selectedIndex = -1
            return
        }
        
        let fanHashValue = selectedAircond.fanSpeed.hashValue
        if fanHashValue == 0 {
            fanControl.selectedIndex = 3
        }
        else {
            fanControl.selectedIndex = fanHashValue - 1
        }
    }
    
    func showTemperature(){
        if selectedAircond.status != .ON || selectedAircond.mode == .DRY {
            temperatureSlider.isEnabled = false
            return
        }
        temperatureSlider.value = Float(selectedAircond.temperature - 16) / 14.0
    }
    
    
    //buttonAction
    
    func modeChanged() {
        if let mode = Aircond.Mode(rawValue: modeControl.selectedIndex) {
            selectedAircond.mode = mode
        }
        
        showMode()
    }
    
    func fanChanged() {
        let index = (fanControl.selectedIndex + 1) % 4
        if let speed = Aircond.FanSpeed(rawValue: index) {
            selectedAircond.fanSpeed = speed
            print(speed)
        }
        
        showFanspeed()
    }
}
