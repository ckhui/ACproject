//
//  ACDashboardViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/10/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class ACDashboardViewController: ACRequestViewController {
    
    var airconds = [Aircond]()
    var boardSize = CGSize()
    
    @IBOutlet weak var boardCollectionView: UICollectionView! {
        didSet{
            boardCollectionView.dataSource = self
            boardCollectionView.delegate = self
            //boardCollectionView.isPagingEnabled = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellWidth = boardCollectionView.frame.width
        let cellHeight = cellWidth / 350 * 150
        boardSize = CGSize(width: cellWidth , height: cellHeight)
        
        boardCollectionView.reloadData()
        // Do any additional setup after loading the view.
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

