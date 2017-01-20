//
//  TestViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/18/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit
import Alamofire

class TestViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ac = Aircond()
        ac.status = .ON
        ac.fanSpeed = .MEDIUM
        ac.mode = .COLD
        ac.temperature = 18
        //aircondScreen.aircond = ac
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //let url = "http://e61f0316.ngrok.io/"
    let url = "https://2420b796.ngrok.io/"

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var tokenTF: UITextField!
    
    
    
    @IBAction func createBtPressed(_ sender: Any) {
        let urlRequest = url + "app_create/"
        
        guard let name = nameTF.text,
            let pw = passwordTF.text
            else { return }
        
        let param = ["user_name": name,
                     "password" : pw]
        
        Alamofire.request(urlRequest, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            print("CREAT")
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
        }

    }

    @IBAction func getBtPressed(_ sender: Any) {
        let urlRequest = url + "get_token/"
        
        guard let name = nameTF.text,
            let pw = passwordTF.text
            else { return }
        
        let param = ["user_name": name ,"password" : pw]

        Alamofire.request(urlRequest, parameters: param).responseString { (response) in
            print("GET")
            print(response.request as Any)  // original URL request
            print(response.response as Any) // URL response
            print(response.result.value as Any)   // result of response serialization
        }
//        
//        Alamofire.request(urlRequest, method: ., parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
//            
//            print("GET")
//            print(response.request as Any)  // original URL request
//            print(response.response as Any) // URL response
//            print(response.result.value as Any)   // result of response serialization
//        }
    }
    
    
    /*
     let urlRequest = url + "app_state/\(aircond.id)?app_token=12345678"
     
     let param = ["status":aircond.statusString(), "mode":aircond.modeString(), "fan_speed": aircond.fanspeedString(), "temperature" : aircond.temperaturString()]
     
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

    */
    
    
    
}
