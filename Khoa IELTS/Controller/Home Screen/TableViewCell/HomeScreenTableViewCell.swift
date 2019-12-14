//
//  HomeScreenTableViewCell.swift
//  Khoa IELTS
//
//  Created by ColWorx on 02/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var sideIndicatorImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    var playButton = UIButton()
    override func awakeFromNib() {
        super.awakeFromNib()
        let screenWidth = UIScreen.main.bounds.size.width
//        let cgWidth = CGFloat(width)
        // Initialization code
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 20, y: 8, width: screenWidth - 40.0, height: 65))
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        let buttonFrame = CGRect(x: screenWidth - 60, y: (self.contentView.frame.size.height/2)-8, width: 25, height: 15)
        playButton.frame = buttonFrame
        playButton.setImage(UIImage(named: "arrow"), for: .normal)
        self.contentView.addSubview(playButton)
        
        self.contentView.addSubview(whiteRoundedView)
        self.contentView.sendSubviewToBack(whiteRoundedView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initializeCell(_ title: String, _ imageName: String) {
        self.sideIndicatorImg.image = UIImage(named: imageName)
        self.title.text = title
    }
}
