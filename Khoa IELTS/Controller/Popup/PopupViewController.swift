//
//  PopupViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 03/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var `continue`: UIButton!
    @IBOutlet weak var startover: UIButton!
    @IBOutlet weak var endtest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.layer.cornerRadius = 10.0;
        self.view.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.60)

    }
    @IBAction func continueTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startOverTapped(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func endTestTapped(_ sender: Any) {
        
    }
}
