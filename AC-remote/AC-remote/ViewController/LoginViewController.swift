//
//  LoginViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/4/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!{
        didSet {
            signInButton.addTarget(self, action: #selector(onSignInButtonPressed) , for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var signUpButton: UIButton!{
        didSet {
            signUpButton.addTarget(self, action: #selector(onSignUpButtonPressed) , for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLogo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func onSignInButtonPressed(){
        //sign in method
    }
    
    func onSignUpButtonPressed(){
        performSegue(withIdentifier: "toSignUpPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUpPage" {
            return
        }
    }
}
