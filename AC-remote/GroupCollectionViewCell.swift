//
//  GroupCollectionViewCell.swift
//  AC-remote
//
//  Created by CKH on 03/04/2017.
//  Copyright © 2017 NEXTAcademy. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    var delegate : GroupCollectionViewCellDelegate?
    var indexPath = IndexPath()
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 3.0
        layer.borderColor = UIColor.customeGreen.cgColor
        layer.cornerRadius = 20.0
        self.layoutMargins.bottom = 10
        // Initialization code
    }
    
    @IBAction func onAllButtonPressed(_ sender: Any) {
        delegate?.ACGroupOnAll(at: indexPath.row)
    }
    
    @IBAction func offAllButtonPressed(_ sender: Any) {
        delegate?.ACGroupOffAll(at: indexPath.row)
    }

}

protocol GroupCollectionViewCellDelegate {
    func ACGroupOnAll(at index : Int)
    func ACGroupOffAll(at index : Int)
}
