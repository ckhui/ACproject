//
//  StatusViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/5/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit
import Alamofire

class StatusViewController: NEXTViewController {
    
    
    var url : String = ""
    
    // titleLabel
    @IBOutlet weak var modeTitle: UILabel!
    @IBOutlet weak var fanTitle: UILabel!
    @IBOutlet weak var temperatureTitle: UILabel!
    
    // display
    @IBOutlet weak var aliasTextField: UITextField!
    @IBOutlet weak var statusDisplay: UISegmentedControl! {
        didSet{
            statusDisplay.addTarget(self, action: #selector(didChangeStatus), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var modeDisplay: UISegmentedControl!{
        didSet{
            modeDisplay.addTarget(self, action: #selector(didChangeMode), for: .valueChanged)
        }
    }
    @IBOutlet var fanSpeedButtons: [UIButton]!
    @IBOutlet weak var fanAutoButton: UIButton!
    
    @IBOutlet weak var temperatureLabel: UILabel!{
        didSet{
            temperatureLabel.isUserInteractionEnabled = true
            let tapOnTemperatureLabel = UITapGestureRecognizer(target: self, action: #selector(onTemperatureLabelPressed))
            temperatureLabel.addGestureRecognizer(tapOnTemperatureLabel)
        }
    }
    
    @IBOutlet weak var plusTemperatureButton: UIButton!
    @IBOutlet weak var minusTemperatureButton: UIButton!
    
    @IBOutlet weak var temperaturePickerToolbar: UIToolbar!
    @IBOutlet weak var temperaturePickerView: UIPickerView! {
        didSet {
            temperaturePickerView.dataSource = self
            temperaturePickerView.delegate = self
        }
    }
    
    var temperaturePickerSelection = [Int]()
    let maxTemperature = 30
    let minTemperature = 16
    
    //buttons
    @IBOutlet weak var modeButton: UIButton!
    @IBOutlet weak var fanButton: UIButton!
    
    
    
    var aircond = Aircond()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initTemperaturePickerView()
        initFanDisplayButtonAction()
        initAircondDetails()
        setStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initAircondDetails(){
        self.title = aircond.alias
        
        aliasTextField.text = aircond.alias
        
        if aircond.status == .PENDING{
            statusDisplay.selectedSegmentIndex = -1
        }else{
            statusDisplay.selectedSegmentIndex = aircond.status.hashValue
        }
        
        modeDisplay.selectedSegmentIndex = aircond.mode.hashValue
        
        
        displayFanSpeed()
        
        temperatureLabel.text = String(aircond.temperature) + " ºC"
    }
    
    func initFanDisplayButtonAction(){
        fanAutoButton.addTarget(self, action: #selector(fanDisplayButtonsPressed), for: .touchUpInside)
        fanSpeedButtons.forEach { fanSpeedButton in
            fanSpeedButton.addTarget(self, action: #selector(fanDisplayButtonsPressed), for: .touchUpInside)
        }
    }
    
    
    // ====== Button ====
    @IBAction func statusButtonPressed(_ sender: Any) {
        let newStatusHashValue = (aircond.status.hashValue + 1) % 2
        statusDisplay.selectedSegmentIndex = newStatusHashValue
        didChangeStatus()
    }
    
    @IBAction func modeButtonPressed(_ sender: Any) {
        let newModeHashValue = (aircond.mode.hashValue + 1) % 3
        modeDisplay.selectedSegmentIndex = newModeHashValue
        didChangeMode()
    }
    
    
    @IBAction func fanButtonPressed(_ sender: Any) {
        var newFanHashValue = (aircond.fanSpeed.hashValue + 1) % 4
        
        if (newFanHashValue == 0 && aircond.mode == .DRY){
            newFanHashValue = 1
        }
        aircond.fanSpeed = Aircond.FanSpeed(rawValue: newFanHashValue) ?? Aircond.FanSpeed.AUTO
        displayFanSpeed()
    }
    
    // ====== Status ====
    func didChangeStatus(){
        let newStatusHashValue = statusDisplay.selectedSegmentIndex
        aircond.status = Aircond.Status(rawValue: newStatusHashValue) ?? Aircond.Status.OFF
        setStatus()
    }
    
    func setStatus(){
        switch (aircond.status){
        case .ON : isStatusOn()
        case .OFF : isStatusOff()
        default: isStatusOff()
        }
    }
    
    func isStatusOn(){
        enableFanButtons(true)
        enableTemperatureButtons(true)
        enableModeButtons(true)
        
        setMode()
    }
    
    func isStatusOff(){
        enableFanButtons(false)
        enableTemperatureButtons(false)
        enableModeButtons(false)
    }
    
    // ====== Mode ====
    func didChangeMode(){
        let newModeHashValue = modeDisplay.selectedSegmentIndex
        aircond.mode = Aircond.Mode(rawValue: newModeHashValue) ?? Aircond.Mode.COLD
        setMode()
    }
    
    func setMode(){
        switch (aircond.mode){
        case .COLD : isModeCold()
        case .DRY : isModeDry()
        case .WET : isModeWet()
        }
    }
    
    func isModeCold(){
        hideFanButtons(false)
        fanButton.isEnabled = true
        hideTemperatureButtons(false)
    }
    func isModeDry(){
        if aircond.fanSpeed == .AUTO {
            aircond.fanSpeed = .MEDIUM
            displayFanSpeed()
        }
        
        hideFanButtons(false, hideAuto: true)
        fanButton.isEnabled = true
        hideTemperatureButtons(true)
    }
    func isModeWet(){
        hideFanButtons(true)
        fanButton.isEnabled = false
        hideTemperatureButtons(false)
    }
    
    // ====== Fan ====
    
    func fanDisplayButtonsPressed(_ button: UIButton){
        let newFanHashValue = button.tag
        aircond.fanSpeed = Aircond.FanSpeed(rawValue: newFanHashValue) ?? Aircond.FanSpeed.AUTO
        displayFanSpeed()
    }
    
    func displayFanSpeed(){
        let fanHashValue = aircond.fanSpeed.hashValue
        if fanHashValue == 0 {
            fanAutoButton.tintColor = UIColor.blue
            fanSpeedButtons.forEach{ button in
                button.tintColor = UIColor.lightGray
            }
        } else {
            fanAutoButton.tintColor = UIColor.lightGray
            fanSpeedButtons.forEach{ button in
                button.tintColor =  button.tag<=fanHashValue ? UIColor.blue : UIColor.lightGray
            }
        }
        
    }
    
    // ====== Temperature ====
    @IBAction func onPlusTemperatureButtonPressed(_ sender: Any) {
        displayTemperatureLabel(temperature: min(aircond.temperature + 1, maxTemperature))
    }
    
    @IBAction func onMinusTemperatureButtonPressed(_ sender: Any) {
        displayTemperatureLabel(temperature: max(aircond.temperature - 1, minTemperature))
    }
    
    func onTemperatureLabelPressed(){
        showTemperaturePicker(withTemperature: aircond.temperature)
    }
    
    func displayTemperatureLabel(temperature : Int){
        aircond.temperature = temperature
        temperatureLabel.text = String(temperature) + " ºC"
    }
    
    
    // ====== Temperaturepickerview ====
    func initTemperaturePickerView(){
        hideTemperaturePicker()
        setTemperaturePickerData(min: minTemperature, max: maxTemperature)
    }
    
    func setTemperaturePickerData(min : Int, max : Int){
        temperaturePickerSelection = []
        for temp in min...max{
            temperaturePickerSelection.append(temp)
        }
    }
    
    @IBAction func cancelPickerButtonPressed(_ sender: Any) {
        hideTemperaturePicker()
    }
    @IBAction func donePickerButtonPressed(_ sender: Any) {
        let selectedIndex = temperaturePickerView.selectedRow(inComponent: 0)
        displayTemperatureLabel(temperature: temperaturePickerSelection[selectedIndex])
        hideTemperaturePicker()
    }
    
    func showTemperaturePicker(withTemperature temperature : Int = 20){
        temperaturePickerView.isHidden = false
        temperaturePickerToolbar.isHidden = false
        
        let selectedRow = aircond.temperature - minTemperature
        temperaturePickerView.selectRow(selectedRow, inComponent: 0, animated: false)
    }
    
    func hideTemperaturePicker(){
        temperaturePickerView.isHidden = true
        temperaturePickerToolbar.isHidden = true
    }
    
    //===== disable/enable button
    func enableModeButtons(_ isEnabled: Bool){
        modeTitle.isEnabled = isEnabled
        modeDisplay.isEnabled = isEnabled
        modeButton.isEnabled = isEnabled
    }
    
    
    func enableFanButtons(_ isEnabled: Bool){
        fanTitle.isEnabled = isEnabled
        fanAutoButton.isEnabled = isEnabled
        fanSpeedButtons.forEach{$0.isEnabled = isEnabled}
        fanButton.isEnabled = isEnabled
    }
    
    func hideFanButtons(_ isHide: Bool, hideAuto isAutoHide: Bool = false){
        fanTitle.isHidden = isHide
        fanAutoButton.isHidden = isHide || isAutoHide
        
        fanSpeedButtons.forEach{$0.isHidden = isHide}
    }
    
    func enableTemperatureButtons(_ isEnabled: Bool){
        temperatureTitle.isEnabled = isEnabled
        temperatureLabel.isEnabled = isEnabled
        plusTemperatureButton.isEnabled = isEnabled
        minusTemperatureButton.isEnabled = isEnabled
        
        if !isEnabled {
            hideTemperaturePicker()
        }
    }
    
    func hideTemperatureButtons(_ isHide: Bool){
        temperatureTitle.isHidden = isHide
        temperatureLabel.isHidden = isHide
        plusTemperatureButton.isHidden = isHide
        minusTemperatureButton.isHidden = isHide
        
        if isHide {
            hideTemperaturePicker()
        }
    }
    
    @IBAction func gopressed(_ sender: Any) {
        sendChangeStatusRequest()
    }
    
    // send request
    func sendChangeStatusRequest(){
        
        let urlRequest = url + "app_state/\(aircond.id)"
        //?app_token=1ea247c92b26eef9907513d43d434d7"
        
        let param : [String:Any] = ["aircond" : ["status":aircond.statusString(), "mode":aircond.modeString(), "fan_speed": aircond.fanspeedString(), "temperature" : aircond.temperaturString()], "app_token" : "efdc4648983cf45a6357e6b4edf069f2", "user_name": "name"]
        
        print(param)
        Alamofire.request(urlRequest, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            //            print("send request")
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
            //            print("sent request")
            //
            var message = "Other Response"
            let popUpTitle = "Status : \(response.result.description.lowercased())"
            if response.result.isSuccess {
                if let returnDict = response.result.value as? [String: String] {
                    if let returnMessage = returnDict["response"]
                    {
                        message = returnMessage
                    }
                }
            }
            self.warningPopUp(withTitle: popUpTitle, withMessage: message)
        }
        
    }
    
    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension StatusViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return temperaturePickerSelection.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(temperaturePickerSelection[row])
    }
    
}
