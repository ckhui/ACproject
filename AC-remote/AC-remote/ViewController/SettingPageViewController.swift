//
//  SettingPageViewController.swift
//  AC-remote
//
//  Created by CKHui on 09/01/2017.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class SettingPageViewController: UIViewController {
    
    @IBOutlet weak var domainUrlTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            backButton.addTarget(self, action: #selector(onBackButtonPressed), for: .touchUpInside)
        }
    }
    
    var urlString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        loadAndDisplayUrl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let urlInput = domainUrlTextField.text ?? ""
        UserDefaults.standard.setValue(urlInput, forKey: "domain")
    }
    
    func loadAndDisplayUrl() {
        urlString = UserDefaults.standard.string(forKey: "domain") ?? ""
        domainUrlTextField.text = urlString
    }
    
    func onBackButtonPressed() {
        
        if urlString == "" && domainUrlTextField.text == "" {
            warningPopUp(withTitle: "Error", withMessage: "No Domain Url saved")
        }else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
