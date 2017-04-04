//
//  RemotePageViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/21/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit
import Alamofire

class RemotePageViewController: ACRequestViewController {
    
    var selectedAircond = Aircond()
    
    
    @IBOutlet weak var onOffButton: UIImageView! {
        didSet{
            onOffButton.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(hanndleOnOffButtonTapped))
            onOffButton.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var fanTitle: UILabel!
    @IBOutlet weak var temperatureTitle: UILabel!
    
    
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
            temperatureSlider.addTarget(self, action: #selector(temperatureSliderEnd(_:)), for: .touchUpInside)
            temperatureSlider.addTarget(self, action: #selector(temperatureSliderEnd(_:)), for: .touchUpOutside)
        }
    }
    
    var temperatureImageView = UIImageView(frame: CGRect.zero) {
        didSet{
            temperatureImageView.contentMode = .scaleAspectFit
        }
    }
    
    var tempCenterView = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTemperatureLabel()
        setTopLogo()
        showAircondValue()
        
        
        tempCenterView = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        tempCenterView.center = view.center
        tempCenterView.layer.cornerRadius = tempCenterView.frame.width / 4
        tempCenterView.layer.masksToBounds = true
        tempCenterView.textAlignment = .center
        tempCenterView.baselineAdjustment = .alignCenters
        tempCenterView.adjustsFontSizeToFitWidth = true
        tempCenterView.backgroundColor = UIColor.lightGray
        
        tempCenterView.font = UIFont(name: "ArialRoundedMTBold", size: 22)
        
        tempCenterView.isHidden = true
        view.addSubview(tempCenterView)
    }
    
    func setupTemperatureLabel(){
        temperatureSlider.addSubview(temperatureImageView)
        
        let tempLabelHeight : CGFloat = 40.0
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: tempLabelHeight * 1.5, height: tempLabelHeight))
        let center = CGPoint(x: temperatureSlider.thumbCenterX, y: temperatureSlider.frame.height + (tempLabelHeight / 2))
        temperatureImageView.frame = rect
        temperatureImageView.center = center
        
        setTemperatureLabel(withTemperature: selectedAircond.temperature)
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
        
        showAircondValue()
    }

    
    func temperatureSliderChanged(_ slider : UISlider){
        
        let temp = 16 + Int(round(slider.value * 14))
        
        tempCenterView.isHidden = false
        tempCenterView.text = "\(temp)ºC"
        
        //set center view color
//        let maxColor = UIColor.hotRed.cgColor
//        
//        var maxR :CGFloat = 0.0 , maxG : CGFloat = 0.0 , maxB : CGFloat = 0.0
//        if maxColor.numberOfComponents > 3,
//            let components = maxColor.components {
//            maxR = components[0]
//            maxG = components[1]
//            maxB = components[2]
//        }
//        
//        let minColor = UIColor.coldBlue.cgColor
//        var minR : CGFloat = 0.0 , minG : CGFloat = 0.0 , minB : CGFloat = 0.0
//        
//        if minColor.numberOfComponents > 3,
//            let components = minColor.components {
//            minR = components[0]
//            minG = components[1]
//            minB = components[2]
//        }
//        
//        
//        let changeTemp : CGFloat = 30 - CGFloat(temp)
//        let changeR = (maxR - minR) / 14.0
//        let changeG = (maxG - minG) / 14.0
//        let changeB = (maxB - minB) / 14.0
//        
//        
//        let color = UIColor.init(red: minR + changeR * changeTemp, green: minG + changeG * changeTemp, blue: minB + changeB * changeTemp, alpha: 1)
        tempCenterView.backgroundColor = UIColor.coldWarmColor(temp: temp)
        
        selectedAircond.temperature = temp
        setTemperatureLabel(at: slider.thumbCenterX, withTemperature: temp)

        
    }
    func temperatureSliderEnd(_ slider : UISlider){
        UIView.animate(withDuration: 0.1, delay: 0.5, options: .curveLinear, animations: { 
            self.tempCenterView.isHidden = true
        }, completion: nil)
    }

    
    func setTemperatureLabel(at pointX : CGFloat,withTemperature temperature : Int) {
        let image = UIImage(named: ImageName.getTemperatureImageName(temperatue: temperature))
        temperatureImageView.image = image
        
        temperatureImageView.center.x = pointX
    }
    
    
    func setTemperatureLabel(withTemperature temp: Int) {
        let value = Float(temp - 16) / 14.0
        temperatureSlider.value = value
        setTemperatureLabel(at: temperatureSlider.thumbCenterX, withTemperature: temp)
        
    }
    
    func showAircondValue() {
        showStatus()
        showMode()
    }
    
    func showStatus(){
        if selectedAircond.status == .ON {
            onOffButton.image = UIImage(named: "power-on")
            statusLabel.text = "\(selectedAircond.alias) is ON"
        } else {
            onOffButton.image = UIImage(named: "power-off")
            statusLabel.text = "\(selectedAircond.alias) is OFF"
        }
    }
    
    
    func showMode() {
        if selectedAircond.status == .ON {
            let modeHash = selectedAircond.mode.hashValue
            modeControl.selectedIndex = modeHash
            modeControl.isEnabled = true
        }
        else{
            modeControl.selectedIndex = -1
            modeControl.isEnabled = false
        }
        
        if selectedAircond.mode == .WET {
            fanControl.isHidden = true
            fanTitle.isHidden = true
        }else{
            fanControl.isHidden = false
            fanTitle.isHidden = false
            fanControl.displaySelectedIndex()
        }
        
        if selectedAircond.mode == .DRY {
            temperatureSlider.isHidden = true
            temperatureImageView.isHidden = true
            temperatureTitle.isHidden = true
            fanControl.hideAuto()
        }else{
            temperatureSlider.isHidden = false
            temperatureImageView.isHidden = false
            temperatureTitle.isHidden = false
            fanControl.showAuto()
        }
        
        showFanspeed()
        showTemperature()
        
        
    }
    
    
    func showFanspeed() {
        if fanControl.isHidden {
            return
        }
        
        if selectedAircond.status != .ON {
            fanControl.selectedIndex = -1
            return
        }
        
        if selectedAircond.mode == .DRY && selectedAircond.fanSpeed == .AUTO {
            selectedAircond.fanSpeed = .HIGH
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
        if temperatureSlider.isHidden {
            return
        }
        
        if selectedAircond.status != .ON {
            temperatureSlider.isEnabled = false
            temperatureImageView.alpha = 0.5
        } else{
            temperatureSlider.isEnabled = true
            temperatureImageView.alpha = 1.0
            temperatureSlider.value = Float(selectedAircond.temperature - 16) / 14.0
        }
        
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
            //print(speed)
        }
        showFanspeed()
    }
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet{
            sendButton.addTarget(self, action: #selector(sendButtonAction(_:)), for: .touchUpInside)
        }
    }
    
    var count = 0
    func sendButtonAction(_ sender : UIButton) {
        count += 1
        sendButton.setTitle("\(sendButton.titleLabel!.text!)  \(count)", for: .normal)
        dump(selectedAircond)
        sendChangeStatusRequest(aircond: selectedAircond)
    }
    
    
    
    
}
