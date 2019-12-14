//
//  MainTabBarViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 07/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

class MainTabBarViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var categoryIdentifier: UIView!
    @IBOutlet weak var analyticsIdentifier: UIView!
    @IBOutlet weak var settingsIdentifier: UIView!
    
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var analyticsBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateScreen("Category")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "FromEndTest"){
            if self.enbaleDisableButtons("Analytics"){
                navigateScreen("Analytics")
                UserDefaults.standard.removeObject(forKey: "FromEndTest")
            }
        }
    }
    @IBAction func categoryBtnTapped(_ sender: Any) {
        if self.enbaleDisableButtons("Category") {
            navigateScreen("Category")
        }
    }
    
    @IBAction func analyticsBtnTapped(_ sender: Any) {
        if self.enbaleDisableButtons("Analytics") {
            navigateScreen("Analytics")
        }
    }
    
    @IBAction func settingsBtnTapped(_ sender: Any) {
        if self.enbaleDisableButtons("Settings") {
            navigateScreen("Settings")
        }
    }
    
    
    func enbaleDisableButtons(_ text: String) -> Bool {
        if text == "Category" {
            
            let selected_home = UIImage(named: "select_home")
            let analytics = UIImage(named: "analytics")
            let settings = UIImage(named: "settings")
            
            
            
            self.categoryBtn.isEnabled = false
            self.categoryBtn.setImage(selected_home, for: .normal)
            
            self.analyticsBtn.isEnabled = true
            self.analyticsBtn.setImage(analytics, for: .normal)
            
            self.settingsBtn.setImage(settings, for: .normal)
            self.settingsBtn.isEnabled = true
            
            self.categoryIdentifier.backgroundColor = UIColor(red: 44.0/255, green: 183.0/255, blue: 221.0/255, alpha: 1)
            self.analyticsIdentifier.backgroundColor = UIColor.clear
            self.settingsIdentifier.backgroundColor = UIColor.clear
            
            return true
        }
        if text == "Analytics" {
            let home = UIImage(named: "home")
            let selected_analytics = UIImage(named: "select_analytics")
            let settings = UIImage(named: "settings")
            
            self.categoryBtn.isEnabled = true
            self.categoryBtn.setImage(home, for: .normal)
            
            
            self.analyticsBtn.isEnabled = false
            self.analyticsBtn.setImage(selected_analytics, for: .normal)
            
            self.settingsBtn.setImage(settings, for: .normal)
            self.settingsBtn.isEnabled = true
            
            self.analyticsIdentifier.backgroundColor = UIColor(red: 44.0/255, green: 183.0/255, blue: 221.0/255, alpha: 1)
            self.categoryIdentifier.backgroundColor = UIColor.clear
            self.settingsIdentifier.backgroundColor = UIColor.clear
            return true
        }
        if text == "Settings" {
            let home = UIImage(named: "home")
            let analytics = UIImage(named: "analytics")
            //let selected_settings = UIImage(named: "selected_settings")
            
            self.categoryBtn.isEnabled = true
            self.categoryBtn.setImage(home, for: .normal)
            
            self.analyticsBtn.setImage(analytics, for: .normal)
            self.analyticsBtn.isEnabled = true
            
            //self.settingsBtn.setImage(selected_settings, for: .normal)
            self.settingsBtn.isEnabled = false
            
            self.settingsIdentifier.backgroundColor = UIColor(red: 44.0/255, green: 183.0/255, blue: 221.0/255, alpha: 1)
            self.analyticsIdentifier.backgroundColor = UIColor.clear
            self.categoryIdentifier.backgroundColor = UIColor.clear
            
            return true
        }
        return false
    }
    
    func navigateScreen(_ screenName: String) {
        var viewController = UIViewController()
        if screenName == "Category" {
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreenViewController
        }
        if screenName == "Analytics" {
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "Analytics") as! AnalyticsViewController
        }
        if screenName == "Settings" {
            viewController = self.storyboard!.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
        }
        self.containerView.addSubview(viewController.view)
        self.addChild(viewController)
        viewController.view.layoutIfNeeded()
        
        viewController.view.frame=CGRect(x: 0 , y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            viewController.view.frame=CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height);
        }, completion:nil)
        return
    }
}
