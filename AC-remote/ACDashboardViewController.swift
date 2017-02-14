//
//  ACDashboardViewController.swift
//  AC-remote
//
//  Created by NEXTAcademy on 2/10/17.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class ACDashboardViewController: UIViewController {
    
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
        
        let cellWidth = boardCollectionView.frame.width / 2
        let cellHeight = cellWidth / 180 * 150
        boardSize = CGSize(width: cellWidth , height: cellHeight)
        
        boardCollectionView.reloadData()
        // Do any additional setup after loading the view.
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return boardSize
    }
 
}

