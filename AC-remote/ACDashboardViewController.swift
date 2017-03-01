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
    var boardSize = CGSize()
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var boardCollectionView: UICollectionView! {
        didSet{
            boardCollectionView.dataSource = self
            boardCollectionView.delegate = self
            //boardCollectionView.isPagingEnabled = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLogoutButton()
        
        ref = FIRDatabase.database().reference()
        airconds = []
        loadFromFirebase()
        
        let cellWidth = boardCollectionView.frame.width
        let cellHeight = cellWidth / 350 * 150
        boardSize = CGSize(width: cellWidth , height: cellHeight)
        
        
        // Do any additional setup after loading the view.
    }
    
    func initLogoutButton(){
        let button = UIBarButtonItem(title: "LogOut", style: .plain, target: self , action: #selector(logoutUser))
        button.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = button
    }
    
    func loadFromFirebase(){
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print("fetching data")
            //print (snapshot.value as Any)
            guard let value = snapshot.value
                else { return }
            let jsonVar = JSON(value)
            let aircondsJson = jsonVar["airconds"]
            
            //print(aircondsJson)
            self.airconds = []
            
            for ac in aircondsJson{
                let tempAc = Aircond(id: ac.0,value: ac.1)
                print("fetch ac... \(ac.0)")
                self.airconds.append(tempAc)
            }
            
            DispatchQueue.main.async {
                self.sortAircondById()
                self.boardCollectionView.reloadData()
            }
        })
        
        ref.child("airconds").observe(.childChanged, with: { (snapshot) in
            
            guard let value = snapshot.value
                else { return }
            
            let json = JSON(value)
            let updatedAc = Aircond(id: snapshot.key, value: json)
            self.updateAircond(ac : updatedAc)
        })
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
        print(indexPath.row)
        
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
        cell.isUserInteractionEnabled = true
        cell.loadingIndicator.stopAnimating()
        //self.backgroundColor = UIColor.clear
    }

    
//    func ACBoardOnOffBtnPressed(aircond: Aircond) {
//        //TODO : only diable selected cell will sending request
//        sendChangeStatusRequest(aircond: aircond)
//    }
}

