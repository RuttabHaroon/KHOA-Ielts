//
//  RecordingsTableViewCell.swift
//  Khoa IELTS
//
//  Created by ColWorx on 03/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class RecordingsTableViewCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var creationDate: UILabel!
    
    var whiteRoundedView = UIView()
    var loadingBar = UIView()
    var imageViewFrame = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension RecordingsTableViewCell {
    func setupCell() {
        whiteRoundedView = UIView(frame: CGRect(x: 20, y: 5, width: UIScreen.main.bounds.size.width - 40, height: 100))
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.5
        
        self.loadingBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: whiteRoundedView.frame.height))
        self.loadingBar.backgroundColor = UIColor(red: 44.0/255, green: 182.0/255, blue: 218.0/255, alpha: 1)
        
        
        imageViewFrame = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: self.loadingBar.frame.size.height))
        imageViewFrame.image = UIImage(named: "fuel")
        
        
        self.loadingBar.addSubview(imageViewFrame)
        whiteRoundedView.addSubview(self.loadingBar)
        
        self.contentView.addSubview(whiteRoundedView)
        self.contentView.sendSubviewToBack(whiteRoundedView)
    }
    
    func animateViewCell() {
        imageViewFrame = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: self.loadingBar.frame.size.height))
        imageViewFrame.image = UIImage(named: "fuel")
        
        
        self.loadingBar.addSubview(imageViewFrame)
        whiteRoundedView.addSubview(self.loadingBar)
    }
}
