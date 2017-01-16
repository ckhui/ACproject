//
//  SignUpViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/11/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class SignUpViewController: NEXTViewController {

    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func onBackButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    func onSignUpButtonPressed(){
        //sign up function
    }

    
}
