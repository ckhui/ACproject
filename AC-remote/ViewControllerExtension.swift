//
//  ViewControllerExtension.swift
//  AC-remote
//
//  Created by CKH on 27/02/2017.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

extension UIViewController{
    
    func warningPopUp(withTitle title : String?, withMessage message : String?){
        let popUP = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        popUP.addAction(okButton)
        present(popUP, animated: true, completion: nil)
    }
    
    func setLogo() {
        let logoImage = UIImage(named: "next_logo")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.image = logoImage
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }
    
    func setNaviBarHeight(height : CGFloat){
        
        guard let bounds = self.navigationController?.navigationBar.bounds
            else { return }
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: height)
    }
    
    func initNaviBar(){
        setNaviBarHeight(height: 80)
        setLogo()
    }
}

class ACRequestViewController : UIViewController {
    
    let url : String = UserDefaults.getDomain()
    let token : String = UserDefaults.getToken()
    let username : String = UserDefaults.getName()
    var loadingBar = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    var manager = Alamofire.SessionManager.default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingBar.activityIndicatorViewStyle = .gray
        loadingBar.hidesWhenStopped = true
        loadingBar.center = view.center
        loadingBar.backgroundColor = UIColor.gray
        loadingBar.layer.cornerRadius = loadingBar.frame.width / 4
        view.addSubview(loadingBar)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        configuration.timeoutIntervalForResource = 5
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func sendChangeStatusRequest(aircond : Aircond){
        loadingBar.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let urlRequest = url + "app_state/\(aircond.id)"
        let param : [String:Any] = ["aircond" : ["status":aircond.statusString(), "mode":aircond.modeString(), "fan_speed": aircond.fanspeedString(), "temperature" : aircond.temperaturString()], "app_token" : token, "user_name": username]
        
        print(param)
        
        manager.request(urlRequest, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            var message = "Other Response"
            let popUpTitle = "Status : \(response.result.description.lowercased())"
            
            switch (response.result) {
            case .success(let value):
                
                if let returnDict = value as? [String: String] {
                    if let returnMessage = returnDict["response"]
                    {
                        message = returnMessage
                        //print(message)
                        if message == "Invalid Token"{
                            self.loadingBar.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            self.popUpToLogUserOut(title: "Error", message: message)
                            return
                        }
                    }
                }
                break
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    message = error.localizedDescription
                }else {
                    message = "Other Error"
                }
            }
            
            self.loadingBar.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.warningPopUp(withTitle: popUpTitle, withMessage: message)
        }
    }
    
    
    func popUpToLogUserOut(title: String, message : String,withCancle cancle : Bool = false){
        let popUP = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
        
        if cancle {
            let okButton = UIAlertAction(title: "OK", style: .default){ (action) in
                NotificationCenter.appSignOut()
            }
            popUP.addAction(okButton)
            let cancleButton = UIAlertAction(title: "Cancle", style: .destructive)
            popUP.addAction(cancleButton)
        }else{
            let okButton = UIAlertAction(title: "LOG OUT", style: .destructive){ (action) in
                NotificationCenter.appSignOut()
            }
            popUP.addAction(okButton)
        }
        
        
        present(popUP, animated: true, completion: nil)
        
        
    }
    
    
    
}

