//
//  LoginViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/4/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    @IBOutlet weak var signInButton: UIButton!{
        didSet {signInButton.addTarget(self, action: #selector(onSignInButtonPressed) , for: .touchUpInside) } }
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet { signUpButton.addTarget(self, action: #selector(onSignUpButtonPressed) , for: .touchUpInside) } }
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel! {
        didSet{
            messageLabel.isHidden = true
            messageLabel.textColor = .red
            messageLabel.font = messageLabel.font.withSize(12)
        }
    }
    
    var message : String = "" {
        didSet{
            if message == "" {
                messageLabel.isHidden = true
            }else{
                messageLabel.text = message
                messageLabel.isHidden = false
            }
        }
    }
    
    var url : String = UserDefaults.getDomain()
    var token : String = UserDefaults.getToken()
    
    var isUrlValid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNaviBar()
        
        view.backgroundColor = UIColor.backgroundColor
        //usernameTextField.placeHolderColor = UIColor(white: 0.8, alpha: 0.5)
        //usernameTextField.textColor = UIColor.white
        //passwordTextField.placeHolderColor = UIColor(white: 0.8, alpha: 0.5)
        //passwordTextField.textColor = UIColor.white
        
        checkForValidDomainUrl()
        
        //check token
        if UserDefaults.getName() != "" && isUrlValid {
            validateUser(username: UserDefaults.getName() , token: token)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkForValidDomainUrl()
        
        if isUrlValid {
            let (isUpdated , newUrl) = getUrlUpdate()
            if isUpdated {
                url = newUrl
                warningPopUp(withTitle: "New Domain Url", withMessage: url)
            }
        }
    }
    
    func checkForValidDomainUrl() {
        let savedUrl = UserDefaults.getDomain()
        if savedUrl == "" {
            isUrlValid = false
            alearToSettingPage()
        }
        else {
            isUrlValid = true
        }
    }
    
    func alearToSettingPage(){
        let popUP = UIAlertController(title: "Invalid Domain Url", message: "Go to Setting Page", preferredStyle: .alert)
        let goButton = UIAlertAction(title: "Go", style: .cancel, handler: { (action) in
            self.performSegue(withIdentifier: "toSettingPage", sender: self)
        })
        popUP.addAction(goButton)
        present(popUP, animated: true, completion: nil)
        
    }
    
    func getUrlUpdate() -> (Bool, String) {
        let savedUrl = UserDefaults.getDomain()
        if url == savedUrl {
            return (false, url)
        }else {
            return (true, savedUrl)
        }
    }
    
    
    
    func onSignInButtonPressed(){
        
        let (isValid, messageString) = validateInput()
        if !isValid {
            message = messageString
        }
        
        
        let urlRequest = url + "get_token/"
        guard let name = usernameTextField.text,
            let pw = passwordTextField.text
            else { return }
        
        let param = ["user_name": name ,"password" : pw]
        
        Alamofire.request(urlRequest, parameters: param).responseString { (response) in
            
            if (response.result.isSuccess) {
                let str = response.result.value ?? ""
                self.validateResponseString(str)
            }else{
                self.warningPopUp(withTitle: "Error", withMessage: "Domain Error")
            }
        }
        
    }
    
    
    func validateInput() -> (Bool, String) {
        if usernameTextField.text == "" {
            return (false, "Username cannot be empty")
        }
        if passwordTextField.text == "" {
            return (false, "Password cannot be empty")
        }
        return (true, "")
    }
    
    func validateResponseString(_ str : String){
        if str == "" {
            message = "Other response"
        }
        
        let component = str.components(separatedBy: "\"")
        if component.count > 1 {
            
            let key = component[1]
            let value = component[component.count - 2]
            
            if key == "app_token"{
                UserDefaults.setToken(token: value)
                UserDefaults.setName(name: usernameTextField.text!)
                //message = value
                NotificationCenter.appSignIn()
            }else {
                message = value
            }
        }else{
            message = component[0]
        }
    }
    
    func onSignUpButtonPressed(){
        performSegue(withIdentifier: "toSignUpPage", sender: self)
    }
    
    func validateUser(username : String, token : String) {
        let urlRequest = url + "validate_token/"
        
        let param = ["user_name": username ,"app_token" : token]
        
        Alamofire.request(urlRequest, parameters: param).responseString { (response) in
            print("validate token")
            if let component = response.result.value?.components(separatedBy: "\"") {
                if component.count > 1 {
                    if component[component.count - 2] == "Your current token is valid" {
                        print("token is valid")
                        NotificationCenter.appSignIn()
                    }
                }
            }
            print(response.result.value as Any)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUpPage" {
            guard let destination = segue.destination as? SignUpViewController
                else { return }
            destination.imageHeight = logoImageView.frame.height
            destination.savedUsername = usernameTextField.text
            destination.url = url
            
            return
        }
        else if segue.identifier == "toSettingPage" {
            return
        }
    }
}
