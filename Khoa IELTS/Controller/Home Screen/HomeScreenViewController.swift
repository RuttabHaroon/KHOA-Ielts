//
//  HomeScreenViewController.swift
//  Khoa IELTS
//
//  Created by ColWorx on 02/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SVProgressHUD



class HomeScreenViewController: UIViewController {
    var menu = [Questions]()
    var sections = [Sections]()
    var ref : DatabaseReference!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Loading")
        tableView.rowHeight = 80
        ref = Database.database().reference()
        UserDefaults.standard.set(self.tableView.frame.size.width, forKey: "tableViewWidth")
        getData()
    }
    @IBAction func popBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getData() {
        ref.child("Questions").observeSingleEvent(of: .value) { (snapshot) in
            let JSON = snapshot.value as! [String: AnyObject]
            for index in JSON {
                let maintitle = index.key
                var image = ""
                
                let content = index.value
                
                for parts in content as! [String:AnyObject] {
                    if parts.key == "image" {
                        image = parts.value as! String
                    } else {
                        var sectionarray = Array<Dictionary<String, AnyObject>>()
                        var sectiondictionary = Dictionary<String, AnyObject>()
                        let partkey = parts.key // Part - 1
                        let partcontent = parts.value as! [String:AnyObject]
                        
                        for p in partcontent {
                            sectiondictionary["title"] = p.key as AnyObject
                            sectiondictionary["selected"] = false as AnyObject
                            sectiondictionary["content"] = p.value
                            sectionarray.append(sectiondictionary)
                        }
                        self.sections.append(Sections(image: image, title: partkey, items: sectionarray, expanded: false))
                    }
                }
                self.menu.append(Questions(maintitle: maintitle, image: image, section: self.sections))
                self.sections.removeAll()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
}

extension HomeScreenViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath) as! HomeScreenTableViewCell

        
        
        let data = menu[indexPath.row]
        cell.initializeCell(data.maintitle, data.image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let data = menu[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailHomeScreen") as! DetailHomeScreenViewController
        let dictionary = ["title":data.maintitle,
                          "image":data.image]
        //WASIQ
        //secondViewController.sections = self.menu[indexPath.row].section
        //END WASIQ
        
        //RUTTAB
        //The code below sort the sections in ascending order
        let sortedSections = self.menu[indexPath.row].section.sorted {
            $0.title < $1.title
        }
        secondViewController.sections = sortedSections
        //END RUTTAB
        
        secondViewController.data = dictionary as! [String : String]
        
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
}
