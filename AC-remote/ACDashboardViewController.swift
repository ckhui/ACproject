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
                VC.selectedAircond = airconds[indexPath.row]
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
    func ACBoardOnOffBtnPressed(aircond: Aircond) {
        sendChangeStatusRequest(aircond: aircond)
    }
}

