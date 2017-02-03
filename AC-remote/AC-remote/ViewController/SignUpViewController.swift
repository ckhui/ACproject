
//
//  SignUpViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/11/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {
    
    var url = ""
    var savedUsername : String?
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel! {
        didSet{
            messageLabel.isHidden = true
            messageLabel.textColor = .red
            messageLabel.font = messageLabel.font.withSize(12)
        }
    }
    
    var message : String = "" {
        didSet{
            if message == ""{
                messageLabel.isHidden = true
            }else {
                messageLabel.text = message
                messageLabel.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var backButton: UIButton!{
        didSet {
            backButton.addTarget(self, action: #selector(onBackButtonPressed) , for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet {
            signUpButton.addTarget(self, action: #selector(onSignUpButtonPressed) , for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.text = savedUsername
    }
    
    func onBackButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    func onSignUpButtonPressed(){
        //sign up function
        let (isValid, messageString) = validateInput()
        if !isValid {
            message = messageString
            return
        }
        
        let urlRequest = url + "app_create/"
        
        guard let name = usernameTextField.text,
            let pw = passwordTextField.text
            else { return }
        
        let param = ["user_name": name,
                     "password" : pw]
        
        Alamofire.request(urlRequest, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if response.result.isSuccess {
                if((response.result.value) != nil) {
                    let jsonVar = JSON(response.result.value!)
                    self.checkResponse(jsonVar["response"].string)
                }
                else{
                    self.warningPopUp(withTitle: "Error", withMessage: "Fail to create account")
                }
            }
        }
    }
    
    func checkResponse(_ response : String?){
        guard let str = response
            else {
                warningPopUp(withTitle: "Error", withMessage: "Response Error")
                return
        }
        if str == "PhoneApp record created, awaiting approval" {
            warningPopUp(withTitle: "Account created", withMessage: "Awaiting approval")
            //go back to log in page
        }else{
            warningPopUp(withTitle: "Error", withMessage: response)
        }
    }
    
    func validateInput() -> (Bool, String) {
        if usernameTextField.text == "" {
            return (false, "Username cannot be empty")
        }
        if passwordTextField.text == "" {
            return (false, "Password cannot be empty")
        }
        if passwordTextField.text != repeatPasswordTextField.text {
            return (false, "Password not match")
        }
        return (true, "")
    }
}
