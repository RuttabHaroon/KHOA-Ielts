//
//  DetailHomeScreenTableViewCell.swift
//  Khoa IELTS
//
//  Created by ColWorx on 02/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class DetailHomeScreenTableViewCell: UITableViewCell {

    let dropdownOpen = UIImage(named:"dropdown")
    let uncheck = UIImage(named: "gray_check")
    let check = UIImage(named: "check")
    let dropdownClosed = UIImage(named: "dropdown_closed")
    
    @IBOutlet weak var sideIndicator: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var playButton = UIButton()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let buttonFrame = CGRect(x: UIScreen.main.bounds.size.width - 60, y: 5, width: 15, height: 25)
        playButton.frame = buttonFrame
        self.contentView.addSubview(playButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func initializeCell(_ imageName: String, _ title: String) {
//        self.sideIndicator.image = UIImage(named: imageName)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.text = title
    }
    
}
