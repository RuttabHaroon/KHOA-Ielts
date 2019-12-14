//
//  RecordingScreenTableViewCell.swift
//  Khoa IELTS
//
//  Created by ColWorx on 10/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class RecordingScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initializeCell(_ topicLabel: String, delegate: UIViewController) {
        self.topicLabel.text = topicLabel
        
        //RUTTAB
        print("MAX NUMBER OF LINES =>",self.topicLabel.calculateMaxLines())
        if let delegate = delegate as? RecordingScreenViewController {
            delegate.numberOfLines = self.topicLabel.calculateMaxLines()
        } else if let delegate = delegate as? TestRecordingScreenViewController {
            delegate.numberOfLines = self.topicLabel.calculateMaxLines()
        }
        //END RUTTAB

    }
    
    func initializeImage(){
        self.checkImage.image = UIImage(named: "tick")
    }
}
