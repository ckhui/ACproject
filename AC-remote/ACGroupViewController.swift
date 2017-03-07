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
    
    @IBOutlet weak var groupTableView: UITableView!{
        didSet{
            groupTableView.dataSource = self
            groupTableView.delegate = self
            groupTableView.estimatedRowHeight = 80
            //groupTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension ACGroupViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return group.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? GroupTableViewCell
            else { return UITableViewCell() }
        
        let tempGroup = group[indexPath.row]
        
        cell.indexPath = indexPath
        cell.groupNameLabel.text = tempGroup.name
        cell.subLabel.text = "#AC : \(tempGroup.getOnOffNumber()) is ON"
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect(group: group[indexPath.row])
    }
    
    func didSelect(group : ACGroup){
        let mainSB = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let remoteVC = mainSB.instantiateViewController(withIdentifier: "ACDashboardViewController") as? ACDashboardViewController {
            
            remoteVC.allowLoadData = false
            remoteVC.navigationItem.leftBarButtonItem = nil
            remoteVC.navigationItem.rightBarButtonItem = nil
            remoteVC.title = group.name
            remoteVC.airconds = group.airconds
            remoteVC.group = []
            
            navigationController?.pushViewController(remoteVC, animated: true)
        }
    }
    
}

extension ACGroupViewController : GroupTableViewCellDelegate {
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
