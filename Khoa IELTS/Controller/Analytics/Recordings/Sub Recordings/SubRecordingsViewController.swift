//
//  SubRecordingsViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 08/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class SubRecordingsViewController: UIViewController {

    var subrecordings = Dictionary<String,AnyObject>()
    
    var savedData = Array<Dictionary<String, AnyObject>>()
    let dropdownOpen = UIImage(named:"dropdown")
    let playButton = UIImage(named: "play")
    let pauseButton = UIImage(named: "pause")
    var i = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainTitle: UILabel!
    
    var sections = [Sections]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(subrecordings)
        getFilesName()
        mainTitle.text = subrecordings["title"] as? String
    }
    
    func getFilesName() {
        do {
            let fileLocation = subrecordings["fileLocation"] as! URL
            
            let folderNames = try FileManager.default.contentsOfDirectory(at: fileLocation, includingPropertiesForKeys: nil, options: [])
            for files in folderNames {
                let fileNames = try FileManager.default.contentsOfDirectory(at: files, includingPropertiesForKeys: nil, options: [])
                let fileNamesString = fileNames.map { $0.lastPathComponent }
                let partName = folderNames.map { $0.lastPathComponent }
                
                let dictionary = ["title" : partName[i],
                                  "items" : fileNamesString] as [String : Any]
                    as [String : Any]
                
                savedData.append(dictionary as [String : AnyObject])
//                sections = [Sections(image: "q1", title: partName[i], items: fileNamesString, expanded: false)]
                i = i + 1
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        for index in savedData {
            let title = index["title"] as! String
            let items = index["items"] as! [String]
//            if sections.isEmpty {
//                sections = [Sections(image: "q1", title: title, items: items, expanded: false)]
//            } else {
//                sections = sections + [Sections(image: "q1", title: title, items: items, expanded: false)]
//            }
            
            print(index)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension SubRecordingsViewController : UITableViewDataSource, UITableViewDelegate, ExpandableHeaderFooterViewDelegate {
    func toggleSection(header: ExpandableHeaderFooterView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        tableView.beginUpdates()
        for i in 0 ..< sections[section].items.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderFooterView()
        //        let imageName = sections[section].image
        //        let image = UIImage(named: imageName)
        //        let imageView = UIImageView(image: image!)
        
        let label = UILabel()
//        let button = UIButton()
        let image = UIImageView()
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 20, y: 8, width: self.view.frame.width - 40, height: 65))
        whiteRoundedView.layer.backgroundColor = UIColor.white.cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        
        header.addSubview(whiteRoundedView)
        
        let frame = CGRect(x: 40, y: 8, width: self.view.frame.width - 40, height: 65)
        label.frame = frame
        label.text = header.customInit(title: sections[section].title, section: section, delegate: self)
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black//(red: 36.0/255.0, green: 132.0/255.0, blue: 144.0/255.0, alpha: 1)
        
//        let buttonFrame = CGRect(x: self.view.frame.width - 60, y: 25, width: 15, height: 25)
//        button.frame = buttonFrame
//
//        button.setImage(dropdownOpen, for: .normal)
        
        let imageFrame = CGRect(x: 20, y: 25, width: 10, height: 35)
        image.frame = imageFrame
        image.image = UIImage(named: sections[section].image)
        
        
//        header.addSubview(button)
        header.addSubview(label)
        header.addSubview(image)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 50
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubRecordingsCell", for: indexPath) as! SubRecordingsTableViewCell
        
        let title = sections[indexPath.section].items[indexPath.row]
//        let playButton = UIButton()
//        let buttonFrame = CGRect(x: self.view.frame.width - 60, y: 5, width: 15, height: 25)
//        playButton.frame = buttonFrame
//
//        playButton.tag = indexPath.row
        //playButton.addTarget(self, action: #selector(changeImage(sender:)), for: .touchUpInside)
//        cell.contentView.addSubview(playButton)
//        cell.titleLabel.text = title
        
        
        return cell
    }
}
