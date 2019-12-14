//
//  SettingCell.swift
//  Khoa IELTS
//
//  Created by ColWorx on 16/09/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperator: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUp(menuItemm: String, index: Int, lastIndex: Bool) {
//        let imageView = cell.viewWithTag(1000) as? UIImageView
//        let title = cell.viewWithTag(1001) as? UILabel
//        let sperator = cell.viewWithTag(1002)
        
        seperator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        
        titleLabel.text = menuItemm // menuItems[indexPath.row]
        
        if index == 3 {
            titleLabel.textColor = UIColor(red:0.73, green:0.73, blue:0.73, alpha:1.0)
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
            sideImageView.isHidden = true
            titleLabelLeadingConstraint.constant = 0
        } else {
            titleLabel.textColor = UIColor.black
            sideImageView.isHidden = false
            titleLabelLeadingConstraint.constant = 15
        }
        
        lastIndex == true ? (seperator.isHidden = true) : (seperator.isHidden = false)
        //(indexPath.row == menuItems.count - 1) ? (seperator.isHidden = true) : (seperator.isHidden = false)
    }
    
}
