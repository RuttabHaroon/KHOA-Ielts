//
//  ReportViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 03/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit
import PieCharts
class ReportViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var chartView: PieChart!
    @IBOutlet weak var frScaling: UIView!
    @IBOutlet weak var grScaling: UIView!
    @IBOutlet weak var lrScaling: UIView!
    @IBOutlet weak var prScaling: UIView!
    @IBOutlet weak var totalBandLabel: UILabel!
    
    
    //18-03-2019
    
    
    @IBOutlet weak var scaling: UIView!
    @IBOutlet weak var frLabel: UILabel!
    @IBOutlet weak var grLabel: UILabel!
    @IBOutlet weak var lrLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
//        mainView.frame.size.width = UIScreen.main.bounds.size.width
        print(mainView.frame.size.width)
    }
    override func viewDidLayoutSubviews() {
        
        mainView.frame.size.width = UIScreen.main.bounds.size.width
    }
    func setupViews() {
        var frband = UserDefaults.standard.string(forKey: "FRBand")
        var grband = UserDefaults.standard.string(forKey: "GRBand")
        var lrband = UserDefaults.standard.string(forKey: "LRBand")
        var prband = UserDefaults.standard.string(forKey: "PRBand")
        var totalB = UserDefaults.standard.string(forKey: "TotalBand")
        
        if frband == nil {
            frband = "0.0"
            grband = "0.0"
            lrband = "0.0"
            prband = "0.0"
            totalB = "0.0"
        }
        let scalingWidth = scaling.frame.size.width
        chartView.models = [
            PieSliceModel(value: Double(frband!)!, color: UIColor.FRBandColor()),
            PieSliceModel(value: Double(grband!)!, color: UIColor.GRBandColor()),
            PieSliceModel(value: Double(lrband!)!, color: UIColor.LRBandColor()),
            PieSliceModel(value: Double(prband!)!, color: UIColor.PRBandColor())
//            PieSliceModel(value: 6.0, color: UIColor.FRBandColor()),
//            PieSliceModel(value: 4.0, color: UIColor.GRBandColor()),
//            PieSliceModel(value: 5.0, color: UIColor.LRBandColor()),
//            PieSliceModel(value: 8.0, color: UIColor.PRBandColor()),
        ]
        
        UIView.animate(withDuration: 1.0, animations: {
//            self.frScaling.frame.size.width = CGFloat((Double(widthScaling)*(self.frband*10))/100)
            self.frScaling.frame.size.width = CGFloat((Double(scalingWidth)*(Double(frband!)!*10))/100)
            self.grScaling.frame.size.width = CGFloat((Double(scalingWidth)*(Double(grband!)!*10))/100)
            self.lrScaling.frame.size.width = CGFloat((Double(scalingWidth)*(Double(lrband!)!*10))/100)
            self.prScaling.frame.size.width = CGFloat((Double(scalingWidth)*(Double(prband!)!*10))/100)
            self.totalBandLabel.text = String(format: "%.1f", Double(totalB!)!)
            
            
            self.frLabel.text = "F:"+String(format: "%.1f", Double(frband!)!)
            self.grLabel.text = "G:"+String(format: "%.1f", Double(grband!)!)
            self.lrLabel.text = "L:"+String(format: "%.1f", Double(lrband!)!)
            self.prLabel.text = "P:"+String(format: "%.1f", Double(prband!)!)
            
        }, completion: nil)
    }
    override func viewWillLayoutSubviews() {
        setupViews()
    }
}
