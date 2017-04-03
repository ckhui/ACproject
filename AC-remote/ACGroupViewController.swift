//
//  ACGroupViewController.swift
//  
//
//  Created by CKH on 07/03/2017.
//
//

import UIKit

class ACGroupViewController: ACRequestViewController {

    var group = [ACGroup]()
    var boardSize = CGSize()
    
    @IBOutlet weak var groupCollectionView: UICollectionView! {
        didSet{
            groupCollectionView.dataSource = self
            groupCollectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension ACGroupViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return group.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GroupCollectionViewCell
            else { return UICollectionViewCell() }
        
        let tempGroup = group[indexPath.row]
        
        cell.indexPath = indexPath
        cell.groupNameLabel.text = tempGroup.name
        cell.subLabel.text = "#AC : \(tempGroup.getOnOffNumber()) is ON"
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect(group: group[indexPath.row])
    }
    
    func didSelect(group : ACGroup){
        let mainSB = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let dashboardVC = mainSB.instantiateViewController(withIdentifier: "ACDashboardViewController") as? ACDashboardViewController {
            
            dashboardVC.allowLoadData = false
            dashboardVC.navigationItem.leftBarButtonItem = nil
            dashboardVC.navigationItem.rightBarButtonItem = nil
            dashboardVC.title = group.name
            dashboardVC.airconds = group.airconds
            dashboardVC.boardSize = boardSize
            dashboardVC.group = []
            
            navigationController?.pushViewController(dashboardVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return boardSize
    }
}

extension ACGroupViewController : GroupCollectionViewCellDelegate {
    func ACGroupOnAll(at index: Int) {
        
        print("ON \(group[index].name)")
        
        let selectedGroup = group[index]
        selectedGroup.airconds.forEach { (ac) in
            if (ac.status == .OFF) {
                let acClone = ac.copy()
                acClone.status = .ON
                self.sendChangeStatusRequest(aircond: acClone)
            }
        }
        
    }
    
    func ACGroupOffAll(at index: Int) {
        print("OFF \(group[index].name)")
        
        let selectedGroup = group[index]
        selectedGroup.airconds.forEach { (ac) in
            if (ac.status == .ON ) {
                let acClone = ac.copy()
                acClone.status = .OFF
                self.sendChangeStatusRequest(aircond: acClone)
            }
        }

        
    }
    
}
