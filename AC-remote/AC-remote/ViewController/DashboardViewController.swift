//
//  DashboardViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 1/4/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class DashboardViewController: UIViewController {
    
    var url : String = ""
    var isUrlValid = false
    var airconds = [Aircond]()
    
    
    
    @IBOutlet weak var timeLabel: UILabel!
    var timeFormat : DateFormatter!
    
    @IBOutlet weak var aircondTableView: UITableView!{
        didSet{
            aircondTableView.delegate = self
            aircondTableView.dataSource = self
            aircondTableView.layer.borderColor = UIColor.black.cgColor
            aircondTableView.layer.borderWidth = 2.0
        }
    }
    
    @IBOutlet weak var settingButton: UIButton! {
        didSet{
            settingButton.addTarget(self, action: #selector(onSettingButtonPressed(_:)) , for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initClock()
        
        checkForValidDomainUrl()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        
        
        
        if isUrlValid {
            let (isUpdated , newUrl) = getUrlUpdate()
            if isUpdated {
                url = newUrl
                warningPopUp(withTitle: "New Domain Url", withMessage: url)
                sendUrlRequest(domainUrl: url)
            }
            else{
                if airconds.count > 0 {
                    aircondTableView.reloadData()
                } else {
                    sendUrlRequest(domainUrl: url)
                }
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkForValidDomainUrl() {
        let savedUrl = UserDefaults.standard.string(forKey: "domain") ?? ""
        if savedUrl == "" {
            isUrlValid = false
            let popUP = UIAlertController(title: "Invalid Domain Url", message: "Go to Setting Page", preferredStyle: .alert)
            let goButton = UIAlertAction(title: "Go", style: .cancel, handler: { (action) in
                self.performSegue(withIdentifier: "toSettingPage", sender: self)
            })
            popUP.addAction(goButton)
            present(popUP, animated: true, completion: nil)
        }
        else{
            url = savedUrl
            isUrlValid = true
        }
    }
    
    func getUrlUpdate() -> (Bool, String) {
        let savedUrl = UserDefaults.standard.string(forKey: "domain") ?? ""
        if url == savedUrl {
            return (false, url)
        }else {
            return (true, savedUrl)
        }
    }
    
    func initClock(){
        timeFormat = DateFormatter()
        timeFormat.dateFormat = Style.clockFormat
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }
    
    func updateClock() {
        let now = Date()
        timeLabel.text = timeFormat.string(from: now)
    }
    
    
    func onSettingButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "toSettingPage", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStatus" {
            
            let statusVC = segue.destination as! StatusViewController
            let index = sender as! IndexPath
            statusVC.aircond = airconds[index.row]
            
            statusVC.url = url
        }
        else if segue.identifier == "toSettingPage"
        {
            return
        }
    }
    
    
    
    func sendUrlRequest(domainUrl : String){
        airconds = []
        
        let fullUrl = url + "app_state?app_token=12345678"
        
        Alamofire.request(fullUrl).responseJSON {responseData -> Void in
            if !responseData.result.isSuccess {
                print("fail loading data")
                self.warningPopUp(withTitle: "Fail to load data", withMessage: "from \(self.url)")
            }
            else if((responseData.result.value) != nil) {
                let jsonVar = JSON(responseData.result.value!)
                
                let airconds = jsonVar["airconds"]
                
                print(airconds)
                for ac in airconds{
                    let tempAc = Aircond(id: ac.0,value: ac.1)
                    self.airconds.append(tempAc)
                }
            }
            DispatchQueue.main.async {
                self.sortAircondById()
                self.aircondTableView.reloadData()
            }

        }
    }
    

//        
//        let _url = URL(string: fullUrl)
//        URLSession.shared.dataTask(with: _url!, completionHandler: {(data, response, error) in
//            guard let data = data, error == nil else { return }
//            do {
//                let json = JSON(data: data)
//                let airconds = json["airconds"]
//                
//                print(airconds)
//                for ac in airconds{
//                    let tempAc = Aircond(id: ac.0,value: ac.1)
//                    self.airconds.append(tempAc)
//                }
//                
//                DispatchQueue.main.async {
//                    self.sortAircondById()
//                    self.aircondTableView.reloadData()
//                }
//                
//            }
//            //            catch let error as NSError {
//            //                print(error)
//            //            }
//        }).resume()
//    }
    
    func sortAircondById(){
        airconds.sort(by: {$0.id < $1.id})
    }
    
}

extension DashboardViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airconds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "body") as? DashboardTableViewCell
            else { return UITableViewCell() }
        
        let ac = airconds[indexPath.row]
        cell.displayDetails(aircond: ac)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "header")
            else { return nil}
        
        let headerView = cell.contentView
        headerView.backgroundColor = UIColor.white
        headerView.layer.borderWidth = 1.0
        headerView.layer.borderColor = UIColor.gray.cgColor
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "footer")
//            else { return nil}
//        
//        let footerView = cell.contentView
//        footerView.backgroundColor = UIColor.white
//        footerView.layer.borderWidth = 1.0
//        footerView.layer.borderColor = UIColor.gray.cgColor
//        return footerView
//    }
//    
//    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
//        return 45
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showStatus", sender: indexPath)
    }
    
    
    
    
}
