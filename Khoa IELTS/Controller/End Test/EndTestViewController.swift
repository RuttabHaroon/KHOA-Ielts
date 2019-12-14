//
//  EndTestViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 03/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit
import PieCharts
import Alamofire
import PKHUD

@available(iOS 11.0, *)
class EndTestViewController: UIViewController {
    
    @IBOutlet weak var scalingview: UIView!
    @IBOutlet weak var textToSpeechText: UILabel!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var totalBandLabel: UILabel!
    @IBOutlet weak var frScalingLabel: UILabel!
    @IBOutlet weak var grScalingLabel: UILabel!
    @IBOutlet weak var lrScalingLabel: UILabel!
    @IBOutlet weak var prScalingLabel: UILabel!
    
    
    
    @IBOutlet weak var pieChart: PieChart!
    @IBOutlet weak var lrScaling: UIView!
    @IBOutlet weak var prScaling: UIView!
    @IBOutlet weak var frScaling: UIView!
    @IBOutlet weak var grScaling: UIView!
    
    @IBOutlet weak var frScalingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var grScalingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lrScalingWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var prScalingWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var roundViewHeightConstraint: NSLayoutConstraint!
    
    var frband = Double()
    var grband = Double()
    var lrband = Double()
    var prband = Double()
    var totalBand = Double()
    var textToSpeech = [String]()
    var categoryname = String()
    var pronouncedWords = Int()
    var rangeOfVocabulary = Int()
    var frequencyCounter = Int()
    var repetitedWords = Int()
    var numberOfSentences = Int()
    var hypotheticalSituation = Int()
    var modalVerbs = Int()
    var collocations = Int()
    var delayedFrequency = Int()
    
    
    var text = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryName.text = categoryname
        self.tableView.rowHeight = 25.0
        
        //RUTTABB
        setUpRoundView()
        //END RUTTABB
    
    }
    
    override func viewWillLayoutSubviews() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        setupPieChart()
    }
    
    func setupPieChart() {
        
        //WASIQ
//        if self.frband > 10 {
//            self.frband = 10.0
//        }
//        if self.grband > 10 {
//            self.grband = 10.0
//        }
//        if self.lrband > 10 {
//            self.lrband = 10.0
//        }
//        if self.prband > 10 {
//            self.prband = 10.0
//        }
        //END WASIQ
        
        //RUTTAB
        if self.frband > 9 {
            self.frband = 9.0
        }
        if self.grband > 9 {
            self.grband = 9.0
        }
        if self.lrband > 9 {
            self.lrband = 9.0
        }
        if self.prband > 9 {
            self.prband = 9.0
        }
        //END RUTTAB
        
        pieChart.models = [
            PieSliceModel(value: self.frband, color: UIColor.FRBandColor()),
            PieSliceModel(value: self.grband, color: UIColor.GRBandColor()),
            PieSliceModel(value: self.lrband, color: UIColor.LRBandColor()),
            PieSliceModel(value: self.prband, color: UIColor.PRBandColor())
        ]
        pieChart.isUserInteractionEnabled = false
        var band = totalBand/4
        band = round(band * 2) / 2
        totalBandLabel.text = String(format: "%.1f", band)
        
        //getting scaling view width.
        let widthScaling = scalingview.frame.size.width

        // calculating scaling
        // (180 * (3.5*10))/100
        UIView.animate(withDuration: 0.5, animations: {
            //WASIQ
//            self.frScalingWidthConstraint.constant = CGFloat((Double(widthScaling)*(self.frband*10))/100)
//            self.grScalingWidthConstraint.constant = CGFloat((Double(widthScaling)*(self.grband*10))/100)
//            self.lrScalingWidthConstraint.constant = CGFloat((Double(widthScaling)*(self.lrband*10))/100)
//            self.prScalingWidthConstraint.constant = CGFloat((Double(widthScaling)*(self.prband*10))/100)
            //END WASIQ
            
            
            //RUTTAB
            self.frScalingWidthConstraint.constant = CGFloat((Double(widthScaling)*(self.frband*9))/100)
            self.grScalingWidthConstraint.constant = CGFloat((Double(widthScaling)*(self.grband*9))/100)
            self.lrScalingWidthConstraint.constant = CGFloat((Double(widthScaling)*(self.lrband*9))/100)
            self.prScalingWidthConstraint.constant = CGFloat((Double(widthScaling)*(self.prband*9))/100)
            //END RUTTAB
            
            self.frScalingLabel.text = "Fr: \(self.frband)"
            self.grScalingLabel.text = "Gr: \(self.grband)"
            self.lrScalingLabel.text = "Lr: \(self.lrband)"
            self.prScalingLabel.text = "Pr: \(self.prband)"
            
            
            UserDefaults.standard.set(band, forKey: "TotalBand")
            UserDefaults.standard.set(self.frband, forKey: "FRBand")
            UserDefaults.standard.set(self.grband, forKey: "GRBand")
            UserDefaults.standard.set(self.lrband, forKey: "LRBand")
            UserDefaults.standard.set(self.prband, forKey: "PRBand")
            
        }, completion: nil)
        textToSpeechText.text = "Pronounced Word: \(pronouncedWords)\nRange of Vocabs: \(rangeOfVocabulary)\nFrequencies result: \(frequencyCounter)\nRepetition of words: \(repetitedWords)\nNumber of Sentences: \(numberOfSentences)\nHypthetical Situation: \(hypotheticalSituation)\nModal verbs: \(modalVerbs)\nDelayed in Sentence: \(delayedFrequency)"
        
        tableView.reloadData()
    }
    @IBAction func exitBtnTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "FromEndTest")
        self.dismiss(animated: true, completion: nil)
    }
}

@available(iOS 11.0, *)
extension EndTestViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textToSpeech.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EndTestCell") as! EndTestTableViewCell

        cell.topicLbl.text = textToSpeech[indexPath.row]
        return cell
    }
}


extension UIColor {
    class func FRBandColor() -> UIColor {
        return UIColor(red: 44.0/255.0, green: 182.0/255, blue: 218.0/255, alpha: 1)
    }
    
    class func GRBandColor() -> UIColor {
        return UIColor(red: 233.0/255.0, green: 153.0/255, blue: 45.0/255, alpha: 1)
    }
    
    class func LRBandColor() -> UIColor {
        return UIColor(red: 250.0/255.0, green: 72.0/255, blue: 106.0/255, alpha: 1)
    }

    class func PRBandColor() -> UIColor {
        return UIColor(red: 38.0/255.0, green: 218.0/255, blue: 157.0/255, alpha: 1)
    }
}


extension EndTestViewController {
    func setUpRoundView() {
        if textToSpeech.count <= 3 {
            roundViewHeightConstraint.constant = 160
        } else {
            //25 is row height
            //height of roundview is 160 and tableview is 103.Thus remaining space in roundView = 160 - 103
            let estimatedHeight = 57 + (25 * textToSpeech.count) + 6
            roundViewHeightConstraint.constant = CGFloat(estimatedHeight)
        }
    }
}
