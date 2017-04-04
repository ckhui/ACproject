//
//  ACDashboardViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/10/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import Alamofire


class ACDashboardViewController: ACRequestViewController {
    
    var airconds = [Aircond]()
    var group = [ACGroup]()
    var boardSize : CGSize!
    var ref: FIRDatabaseReference!
    var allowLoadData = true
    
    @IBOutlet weak var boardCollectionView: UICollectionView! {
        didSet{
            boardCollectionView.dataSource = self
            boardCollectionView.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if boardSize == nil {
            let cellWidth = boardCollectionView.frame.width
            let cellHeight = cellWidth / 350 * 120 //150
            boardSize = CGSize(width: cellWidth , height: cellHeight)
        }
        
        if allowLoadData {
            setTopLogo()
            airconds = []
            initLogoutButton()
            ref = FIRDatabase.database().reference()
            loadFromFirebase()
            listenToFirebase()
        }else{
            boardCollectionView.reloadData()
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func initLogoutButton(){
        let button = UIBarButtonItem(title: "LogOut", style: .plain, target: self , action: #selector(logoutUser))
        button.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = button
    }
    
    func loadFromFirebase(){
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            //print("fetching data")
            //print (snapshot.value as Any)
            guard let value = snapshot.value
                else { return }
            let jsonVar = JSON(value)
            let aircondsJson = jsonVar["airconds"]
            
            let groupsJson = jsonVar["aircond_group"]
            if groupsJson != JSON.null
            {
                self.initACGroups(groupsJson)
            }
            
            //print(aircondsJson)
            self.airconds = []
            
            for ac in aircondsJson{
                
                if ac.1 == JSON.null{
                    continue
                }
                
                let tempAc = Aircond(id: ac.0,value: ac.1)
                //print("fetch ac... \(ac.0)")
                self.airconds.append(tempAc)
            }
            
            DispatchQueue.main.async {
                self.saveACToGroup()
                self.sortAircondById()
                self.boardCollectionView.reloadData()
            }
        })
    }
    
    func listenToFirebase(){
        ref.child("airconds").observe(.childChanged, with: { (snapshot) in
            
            guard let value = snapshot.value
                else { return }
            
            let json = JSON(value)
            let updatedAc = Aircond(id: snapshot.key, value: json)
            self.updateAircond(ac : updatedAc)
        })
        
        
        //        ref.child("aircond_group").observe(.childChanged, with: { (snapshot) in
        //
        //            guard let value = snapshot.value
        //                else { return }
        //
        //            let json = JSON(value)
        //            let updatedAc = ACGroup(id: snapshot.key, name: json["titile"].string)
        //            //self.updateAircond(ac : updatedAc)
        //        })
        
        
        
    }
    
    func initACGroups(_ json : JSON){
        
        
        json.forEach { (key, value) in
            if value != JSON.null {
                let newGroup = ACGroup(id: key, name: value["title"].string)
                //print( "Group : add new group -> \(newGroup.id) : \(newGroup.name)")
                group.append(newGroup)
            }
        }
    }
    
    func saveACToGroup(){
        
        airconds.forEach { (ac) in
            for groupId in ac.group {
                if let gp = group.first(where: {$0.id == groupId}) {
                    //print("Group : add ac to group -> \(gp.name)")
                    gp.airconds.append(ac)
                } else{
                    //print("GROUP : group info missing for id : \(groupId)")
                    let newGroup = ACGroup(id: groupId, name: groupId)
                    newGroup.airconds.append(ac)
                    group.append(newGroup)
                }
            }
        }
        
        //dump (group)
        group = group.filter { (gp) -> Bool in
            gp.airconds.count > 0
        }
    }
    
    func sortAircondById(){
        airconds.sort(by: {$0.id < $1.id})
    }
    
    func updateAircond(ac : Aircond){
        let index = airconds.index { $0.id == ac.id }
        if let index = index {
            airconds[index] = ac
            let indexPath = IndexPath(item: index, section: 0)
            boardCollectionView.reloadItems(at: [indexPath])
        }
    }
    
    func logoutUser(){
        popUpToLogUserOut(title: "LogOut", message: "Confirm ?", withCancle : true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRemotePage" {
            if let VC =  segue.destination  as? RemotePageViewController,
                let indexPath = sender as? IndexPath {
                VC.selectedAircond = airconds[indexPath.row].copy()
            }
        }
            
            
        else if segue.identifier == "toGroupView" {
            if let VC = segue.destination as? ACGroupViewController {
                VC.group = group
                VC.boardSize = boardSize
            }
        }
        
        
    }
    
}

extension ACDashboardViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return airconds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ACBoardCell", for: indexPath) as? ACBoardCollectionViewCell
            else { return UICollectionViewCell() }
        
        cell.showACStatus(airconds[indexPath.row])
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return boardSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        performSegue(withIdentifier: "toRemotePage", sender: indexPath)
        
    }
    
}

extension ACDashboardViewController : ACBoardCellDelegate {
    func ACBoardOnOffBtnPressed(indexPath: IndexPath) {
        onOffPressed(at: indexPath)
    }
    
    func onOffPressed(at indexPath : IndexPath) {
        //ac : Aircond){
        guard let selectedCell = boardCollectionView.cellForItem(at: indexPath) as? ACBoardCollectionViewCell
            else { return }
        
        
        requestStart(cell: selectedCell)
        
        let url : String = UserDefaults.getDomain()
        let token : String = UserDefaults.getToken()
        let username : String = UserDefaults.getName()
        let ac = airconds[indexPath.row].copy()
        ac.changeOnOffStatus()
        
        let urlRequest = url + "app_state/\(ac.id)"
        let param : [String:Any] = ["aircond" : ["status":ac.statusString(), "mode":ac.modeString(), "fan_speed": ac.fanspeedString(), "temperature" : ac.temperaturString()], "app_token" : token, "user_name": username]
        
        
        //        let configuration = URLSessionConfiguration.default
        //        configuration.timeoutIntervalForRequest = 3
        //        configuration.timeoutIntervalForResource = 3
        //        manager = Alamofire.SessionManager(configuration: configuration)
        //
        
        manager.request(urlRequest, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            var message = "Other Response"
            let popUpTitle = "Status : \(response.result.description.lowercased())"
            if response.result.isSuccess {
                if let returnDict = response.result.value as? [String: String] {
                    if let returnMessage = returnDict["response"]
                    {
                        message = returnMessage
                        //print(message)
                        
                        if message == "Invalid Token"{
                            
                            self.requestEnd(cell : selectedCell, title : popUpTitle, message : message)
                            return
                        }
                    }
                }
            }
            self.requestEnd(cell : selectedCell, title : popUpTitle, message : message)
            
        }
    }
    
    
    func requestStart(cell : ACBoardCollectionViewCell) {
        if !cell.isLoadingSetup {
            cell.setUpLoadingIndicator()
        }
        
        cell.isUserInteractionEnabled = false
        cell.loadingIndicator.startAnimating()
        //self.backgroundColor = UIColor.green
    }
    
    func requestEnd(cell : ACBoardCollectionViewCell, title : String , message : String) {
        cell.loadingIndicator.stopAnimating()
        //cell.messageLabel.alpha = 1.0
        if title == "Status : failure"{
            cell.messageLabel.textColor = UIColor.red
        }
        else if title == "Status : success" {
            cell.messageLabel.textColor = UIColor.customeGreen
        }
        
        
        cell.messageLabel.text = "\(title) : \n\(message)"
        cell.messageLabel.isHidden = false
        UIView.animate(withDuration: 1.0, delay: 1.0, options: .curveEaseIn, animations: {
            cell.messageLabel.alpha = 0.0
        }) { (bool) in
            cell.messageLabel.isHidden = true
            cell.messageLabel.alpha = 1.0
            cell.isUserInteractionEnabled = true
        }
        
        //        cell.isUserInteractionEnabled = true
        //self.backgroundColor = UIColor.clear
    }
    
    
    //    func ACBoardOnOffBtnPressed(aircond: Aircond) {
    //        //TODO : only diable selected cell will sending request
    //        sendChangeStatusRequest(aircond: aircond)
    //    }
}

