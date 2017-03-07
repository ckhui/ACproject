//
//  GroupTableViewCell.swift
//  AC-remote
//
//  Created by CKH on 06/03/2017.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    var delegate : GroupTableViewCellDelegate?
    var indexPath = IndexPath()
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onAllButtonPressed(_ sender: Any) {
        delegate?.ACGroupOnAll(at: indexPath.row)
    }
    
    @IBAction func offAllButtonPressed(_ sender: Any) {
        delegate?.ACGroupOffAll(at: indexPath.row)
    }

}

protocol GroupTableViewCellDelegate {
    func ACGroupOnAll(at index : Int)
    func ACGroupOffAll(at index : Int)
}
