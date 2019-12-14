//
//  DetailHomeScreenViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 02/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit



class DetailHomeScreenViewController: UIViewController {
    
    @IBOutlet weak var mainHeadingTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let dropdownOpen = UIImage(named:"dropdown")
    let uncheck = UIImage(named: "gray_check")
    let check = UIImage(named: "check")
    let dropdownClosed = UIImage(named: "dropdown_closed")
    
    var selectedIndex = [String]()
    var data = [String: String]()
    var expandedSection = -1
    var sendertag = 0
    var sections = [Sections]()
    var sortedSections = [Sections]()
    
    //RUTTAB
    var onTopicSelected: (([String]) -> ())?
    //END RUTTAB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.mainHeadingTitle.text = data["title"]
        
        tableView.rowHeight = 40
        
    }
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    
    //WASIQ
    @objc func randomStartTapped(_ sender: AnyObject) {
        let button = sender as? UIButton
        let cell = button?.superview?.superview as? UITableViewCell
        let indexPath = tableView.indexPath(for: cell!)

        var topics = [String]()
        var i = 0

        for index in 0..<(sections[(indexPath?.section)!].items[0]["content"] as! [AnyObject]).count {
            let currentTitle = ((sections[(indexPath?.section)!].items[0]["content"]) as! [AnyObject])[index] as! String
            topics.append(currentTitle)
            i = i + 1
        }

        let recording = storyboard?.instantiateViewController(withIdentifier: "RecordingScreen") as! RecordingScreenViewController

        //RUTTAB
        recording.isTestNow = false
        //END RUTTAB

        if(!selectedIndex.isEmpty){
            recording.data = ["title" : data["title"]!,
                              "part" : sections[(indexPath?.section)!].title,
                              "topics" : selectedIndex,
                              "topicTitle" : sections[(indexPath?.section)!].items[sendertag]["title"] as! String
                ] as [String:AnyObject]
        } else {
            recording.data = ["title" : data["title"]!,
                              "part" : sections[(indexPath?.section)!].title,
                              "topics" : topics,
                              "topicTitle" : sections[(indexPath?.section)!].items[sendertag]["title"] as! String
                ] as [String : AnyObject] //information
        }
        self.navigationController?.pushViewController(recording, animated: true)
    }
    //END WASIQ
    
}

extension DetailHomeScreenViewController : UITableViewDataSource, UITableViewDelegate, ExpandableHeaderFooterViewDelegate {

    
    func toggleSection(header: ExpandableHeaderFooterView, section: Int) {

        sections[section].expanded = !sections[section].expanded
        
        tableView.beginUpdates()
        
        for i in 0 ..< sections[section].items.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .fade)
        }
        tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count + 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderFooterView()
        
        let label = UILabel()
        let button = UIButton()
        let image = UIImageView()
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 20, y: 8, width: self.tableView.frame.width - 40, height: 65))
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        
        let frame = CGRect(x: 20, y: 0, width: whiteRoundedView.frame.width - 20, height: 65)
        label.frame = frame
        label.text = header.customInit(title: sections[section].title, section: section, delegate: self)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.numberOfLines = 0
        
        let buttonFrame = CGRect(x: whiteRoundedView.frame.width - 40, y: 20, width: 15, height: 25)
        button.frame = buttonFrame
        
        button.setImage(dropdownOpen, for: .normal)
        
        let imageFrame = CGRect(x: 0, y: 15, width: 10, height: 35)
        image.frame = imageFrame
        image.image = UIImage(named: sections[section].image)
        
        
        whiteRoundedView.addSubview(button)
        whiteRoundedView.addSubview(label)
        whiteRoundedView.addSubview(image)
        
        header.addSubview(whiteRoundedView)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 40
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == sections[indexPath.section].items.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RandomButtonCell") as! RandomButtonCell

            //cell.setUpData(of: tableView, sections: sections, selectedIndex: selectedIndex, data: data, sendertag: sendertag, vc: self)

            cell.randomStartButton.addTarget(self, action: #selector(self.randomStartTapped(_:)), for: .touchUpInside)
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailHomeScreenCell") as! DetailHomeScreenTableViewCell
        
//        if(indexPath.row == sections[indexPath.section].items.count) {
//            let randomStartBtn = UIButton()
//            let buttonFrame = CGRect(x: self.view.frame.width - 200, y: 5, width: 150, height: 25)
//            randomStartBtn.frame = buttonFrame
//
//            randomStartBtn.setTitle("Random Start", for: .normal)
//            randomStartBtn.setTitleColor(UIColor(red: 44.0/255, green: 182.0/255, blue: 224.0/255, alpha: 1), for: .normal)
//
//            randomStartBtn.addTarget(self, action: #selector(randomStartTapped(_:)), for: .touchUpInside)
//            cell.contentView.addSubview(randomStartBtn)
//
//            cell.backgroundColor = UIColor.red
//
//            return cell
//        }
        
        let item = sections[indexPath.section].items[indexPath.row]

        
        if (item["selected"] as? Bool ?? false) {
            cell.playButton.setImage(check, for: .normal)
            cell.playButton.isSelected = true
        } else {
            cell.playButton.setImage(uncheck, for: .normal)
            cell.playButton.isSelected = false
        }
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(changeImage(sender:)), for: .touchUpInside)
        
        
        cell.initializeCell("", item["title"] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @objc func changeImage(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at:buttonPosition)
        
        let totalRows = self.tableView.numberOfRows(inSection: (indexPath?.section)!)
        
        
        for index in 0..<sections[(indexPath?.section)!].items.count {
            sections[(indexPath?.section)!].items[index]["selected"] = false as AnyObject
            self.tableView.reloadRows(at: [IndexPath(row: index, section: (indexPath?.section)!)], with: .none)
        }
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            selectedIndex.removeAll()
            sendertag = sender.tag
            for index in 0..<(sections[(indexPath?.section)!].items[sender.tag]["content"] as! [AnyObject]).count {
                let currentTitle = ((sections[(indexPath?.section)!].items[sender.tag]["content"]) as! [AnyObject])[index] as! String
                selectedIndex.append(currentTitle)
            }
            sections[(indexPath?.section)!].items[sender.tag]["selected"] = true as AnyObject
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: (indexPath?.section)!)], with: .none)
            print("Selected Topics: \(selectedIndex)")
            
            //onTopicSelected!(selectedIndex)!
            
        } else {
            sendertag = sender.tag
            for index in 0..<(sections[(indexPath?.section)!].items[sender.tag]["content"] as! [AnyObject]).count {
                let currentTitle = ((sections[(indexPath?.section)!].items[sender.tag]["content"]) as! [AnyObject])[index] as! String
                if(selectedIndex.contains(currentTitle)) {
                    let currentTitleIndex = selectedIndex.firstIndex(of: currentTitle)
                    selectedIndex.remove(at: currentTitleIndex!)
                }
            }
            sections[(indexPath?.section)!].items[sender.tag]["selected"] = false as AnyObject
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: (indexPath?.section)!)], with: .none)
            print("Selected Topics: \(selectedIndex)")
        }
    }
    
}
