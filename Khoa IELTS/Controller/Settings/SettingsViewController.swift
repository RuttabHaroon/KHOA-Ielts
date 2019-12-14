//
//  SettingsViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 07/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var clickableView: UIView!
    @IBOutlet weak var boostSpeakingSkillButton: UIButton!
    
    var menuItems = ["Contact Khoa", "Report a Bug", "Suggest an Idea", "Spread the Word", "Review our App", "Share our App"]
    
    let colorsArray = [UIColor.white, UIColor.clear]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    
    @IBAction func visitKhoaWebsite(_ sender: Any) {
        print("I am hete")
        let alert = UIAlertController(title: "Boot your IELTS speaking skill", message: "Link will be provided later", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension SettingsViewController {
    func setUp() {
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = false
        containerView.layer.shadowRadius = 15
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: -1, height: -1)
        containerView.layer.shadowOpacity = 0.15
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.isScrollEnabled = false
        
        self.tableView.separatorStyle = .none
        
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        makeCoverClickable()
        
        //boostSpeakingSkillButton.addTarget(self, action: #selector(goToKhoaWebsite), for: .touchUpOutside)
        
        //self.tableView.separatorColor = UIColor.clear
    }
    
    @objc func goToKhoaWebsite() {
        print("I am hete")
        let alert = UIAlertController(title: "Boots your IELTS speaking skill", message: "This will redirect the user to the online course", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeCoverClickable() {
       // coverImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToKhoaWebsite))
        //coverImageView.addGestureRecognizer(tap)
       clickableView.addGestureRecognizer(tap)
    }
    
    @objc func visitweb() {
        print("cover image was clicked")
    }
    
    func contactKhoa(subject: String) {
        
        // create mail subject
        let subject = subject
        
        // define email address
        let mail = "info@khoaielts.com"
        
        // define allowed character set
        let set = CharacterSet.urlHostAllowed
        
        // create the URL
        let url = URL(string: "mailto:?to=\(mail.addingPercentEncoding(withAllowedCharacters: set) ?? "")&subject=\(subject.addingPercentEncoding(withAllowedCharacters: set) ?? "")")
        // load the URL
        if let url = url {
            UIApplication.shared.openURL(url)
        }
    }
    
    func openInAppStore() {
        let alert = UIAlertController(title: "Review our App", message: "This will redirect to the AppStore", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func shareApp() {
        let activityController = UIActivityViewController(activityItems: ["Hey, download this amazing app if you want to achieve a good IELTS speaking score![AppStore Link]"], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }


}

//MARK:- TABLEVIEW DATASOURCE AND DELEGATE
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as? SettingCell else {
            fatalError("The dequeued cell is not of type SettingCell")
        }
        
        
        var lastIndex = false
        (indexPath.row == menuItems.count - 1) ? (lastIndex = true) : (lastIndex = false)
        
        cell.setUp(menuItemm: menuItems[indexPath.row], index: indexPath.row, lastIndex: lastIndex)
        
//        let imageView = cell.viewWithTag(1000) as? UIImageView
//        let title = cell.viewWithTag(1001) as? UILabel
//        let sperator = cell.viewWithTag(1002)
//
//        sperator?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
//
//        title?.text = menuItems[indexPath.row]
//
//        if indexPath.row == 3 {
//            title?.textColor = UIColor(red:0.73, green:0.73, blue:0.73, alpha:1.0)
//            title?.font = UIFont.boldSystemFontOfSize(16.0)
//            imageView?.isHidden = true
//        } else {
//            title?.textColor = UIColor.black
//            imageView?.isHidden = false
//        }
//
//        (indexPath.row == menuItems.count - 1) ? (sperator?.isHidden = true) : (sperator?.isHidden = false)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2  {
            contactKhoa(subject: menuItems[indexPath.item])
        } else if indexPath.item == 4 {
            openInAppStore()
        } else if indexPath.item == 5 {
            shareApp()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

