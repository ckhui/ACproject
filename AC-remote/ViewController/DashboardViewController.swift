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
import Firebase


class DashboardViewController: UIViewController {
    
    var url : String = UserDefaults.getDomain()
    var airconds = [Aircond]()
    var token : String = ""
    
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
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initClock()
        initLogoutButton()

        ref = FIRDatabase.database().reference()
        airconds = []
        loadFromFirebase()
        // TODO : listen to firebase
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func initLogoutButton(){
        let button = UIBarButtonItem(title: "LogOut", style: .plain, target: self , action: #selector(logoutUser))
        button.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = button
    }
    
    func logoutUser(){
        print("logOut")
        NotificationCenter.appSignOut()
    }
    
    func loadFromFirebase(){
        
        ref.observe(.value, with: { (snapshot) in
            print("fetch data")
            //print (snapshot.value as Any)
            guard let value = snapshot.value
                else { return }
            let jsonVar = JSON(value)
            let aircondsJson = jsonVar["airconds"]
            
            //print(aircondsJson)
            self.airconds = []
            
            for ac in aircondsJson{
                let tempAc = Aircond(id: ac.0,value: ac.1)
                print("fetch ac...")
                self.airconds.append(tempAc)
            }
            
            DispatchQueue.main.async {
                self.sortAircondById()
                self.aircondTableView.reloadData()
            }
        })
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
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStatus" {
            
            let statusVC = segue.destination as! StatusViewController
            let index = sender as! IndexPath
            statusVC.aircond = airconds[index.row]
            
            statusVC.url = url
        }
        
        if segue.identifier == "uisegue" {
            let remoteVC = segue.destination as! RemoteViewController
            remoteVC.aircond = airconds[0]

            
        }
        
        if segue.identifier == "test2" {
            let boardVC = segue.destination as! ACDashboardViewController
            boardVC.airconds = airconds
        }
    }
    
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


/*
 
 
 func sendUrlRequest(domainUrl : String){
 airconds = []
 //airconds.append(Aircond())
 let fullUrl = url + "app_state?app_token=\(token)"
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
 */
