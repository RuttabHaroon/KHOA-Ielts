//
//  SubRecordingsTableViewCell.swift
//  Khoa IELTS
//
//  Created by ColWorx on 08/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class SubRecordingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
