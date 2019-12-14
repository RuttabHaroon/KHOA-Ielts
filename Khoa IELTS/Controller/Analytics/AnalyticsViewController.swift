//
//  AnalyticsViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 03/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit
class AnalyticsViewController: UIViewController {

    @IBOutlet weak var adViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var recordingBtn: UIButton!
    
    @IBOutlet weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportBtn.isEnabled = false
        
        let report : ReportViewController = self.storyboard!.instantiateViewController(withIdentifier: "Report") as! ReportViewController
        self.containerView.addSubview(report.view)
        self.addChild(report)
        report.view.layoutIfNeeded()
        
        report.view.frame=CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.size.width, height: self.containerView.frame.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            report.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.containerView.frame.size.height);
        }, completion:nil)
        
//        checkAdsAvailable()
    }
    @IBAction func reportBtnTapped(_ sender: Any) {
        reportBtn.isEnabled = false
        recordingBtn.isEnabled = true
        let report : ReportViewController = self.storyboard!.instantiateViewController(withIdentifier: "Report") as! ReportViewController
        self.containerView.addSubview(report.view)
        self.addChild(report)
        report.view.layoutIfNeeded()
        
        report.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: self.containerView.frame.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            report.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.containerView.frame.size.height);
            
            
            self.recordingBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            self.recordingBtn.setTitleColor(UIColor.lightGray, for: .normal)
            
            self.reportBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            self.reportBtn.setTitleColor(UIColor.black, for: .normal)
           self.indicatorViewLeadingConstraint.constant = 20.0
        }, completion:nil)
    }
    @IBAction func recordingBtnTapped(_ sender: Any) {
        
        reportBtn.isEnabled = true
        recordingBtn.isEnabled = false
        
        
        let report : RecordingsViewController = self.storyboard!.instantiateViewController(withIdentifier: "Recordings") as! RecordingsViewController
        self.containerView.addSubview(report.view)
        self.addChild(report)
        report.view.layoutIfNeeded()
        
        report.view.frame=CGRect(x: UIScreen.main.bounds.size.width , y: 0, width: UIScreen.main.bounds.size.width, height: self.containerView.frame.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            report.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.containerView.frame.size.height);
            
            self.recordingBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            self.recordingBtn.setTitleColor(UIColor.black, for: .normal)
            
            self.reportBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
            self.reportBtn.setTitleColor(UIColor.lightGray, for: .normal)
            self.indicatorViewLeadingConstraint.constant = 80.0
        }, completion:nil)
    }
    
//    func checkAdsAvailable() {
//        let adsAvailable = true
//        if adsAvailable {
//           self.adViewHeightConstraint.constant = 40
//        }
//    }
}
