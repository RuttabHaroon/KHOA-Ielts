//
//  FirstViewController.swift
//  Khoa IELTS
//
//  Created by Office on 4/23/19.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit
//RUTTAB
import FirebaseDatabase
import SVProgressHUD
//END RUTTAB

class FirstViewController: UIViewController {

    @IBOutlet weak var testNow: RoundedButtons!
    @IBOutlet weak var practice: RoundedButtons!
    @IBOutlet weak var testNowWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var practiceWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var kisLogo: UIImageView!
    @IBOutlet weak var khoaIELTSLogo: UIImageView!
    
    //RUTTAB
    var ref : DatabaseReference!
    var selectedQuestion = ""
    let questionsArray = ["City, Traffic & Transport",
                          "Environment, Animal & Nature",
                          "Fashion & Shopping",
                          "Food",
                          "Health & Well-being",
                          "History, Art & Culture",
                          "Home, Hometown & Accommodation",
                          "Language, Study & Education",
                          "People, Relationship & Communication",
                          "Personal Matters & Hobbies",
                          "Science & Technology",
                          "Society & Community",
                          "Sport, Indoor & Outdoor activities",
                          "TV, Media & Entertainment",
                          "Travel & Holiday",
                          "Work, Employment & Business"]
    
    
    //let questionsArray = ["People, Relationship & Communication"]
    
    
    //let questionsArray = ["TV, Media & Entertainment"]
    
    //var data = Array<Dictionary<String,AnyObject>>()
    var data = Array<Dictionary<String,AnyObject>>()
    //END RUTTAB
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
//        setup()
    }
    func setup() {
        
        self.khoaIELTSLogo.alpha = 0
        self.kisLogo.alpha = 0
        
        //RUTTAB
//        UIView.animate(withDuration: 0.8, animations: {
//            self.khoaIELTSLogo.alpha = 1
//        }) { _ in
//            UIView.animate(withDuration: 1, animations: {
//                self.kisLogo.alpha = 1
//            }, completion: { _ in
//                UIView.animate(withDuration: 1.2, animations: {
//                    self.testNowWidthConstraint.constant = 300
//                    self.view.layoutIfNeeded()
//                }) { _ in
//                    UIView.animate(withDuration: 1.3, animations: {
//                        self.practiceWidthConstraint.constant = 300
//                        self.view.layoutIfNeeded()
//                    }, completion: nil)
//                }
//            })
//        }
        
        //self.testNowWidthConstraint.constant = 300
        //self.practiceWidthConstraint.constant = 300
        
        animateViews()
        //END RUTTAB
        
        //WASIQ CODE
//        UIView.animate(withDuration: 0.2, animations: {
//            self.testNowWidthConstraint.constant = 300
//            self.view.layoutIfNeeded()
//        }) { _ in
//            UIView.animate(withDuration: 0.3, animations: {
//                self.practiceWidthConstraint.constant = 300
//                self.view.layoutIfNeeded()
//            }, completion: nil)
//        }
        //END WASIQ CODE
        
    }
    
    //RUTTAB
    func animateViews() {
        
        UIView.animate(withDuration: 1.3, animations: {
            self.khoaIELTSLogo.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 1, animations: {
                self.khoaIELTSLogo.alpha = 0
            }, completion: { _ in
                UIView.animate(withDuration: 1.3 , animations: {
                     self.kisLogo.alpha = 1
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.testNowWidthConstraint.constant = 300
                        self.view.layoutIfNeeded()
                    }) { _ in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.practiceWidthConstraint.constant = 300
                            self.view.layoutIfNeeded()
                        }, completion: nil)
                    }
                })
            })
        }
        
//        UIView.animate(withDuration: 1.3, animations: {
//            self.khoaIELTSLogo.alpha = 1
//        }) { _ in
//            UIView.animate(withDuration: 1, animations: {
//                self.khoaIELTSLogo.alpha = 0
//            }, completion: { _ in
//                UIView.animate(withDuration: 1.3, animations: {
//                     self.kisLogo.alpha = 1
//                }, completion: { _ in
//                    print("Completed")
//                })
//            })
//        }
        
    }
    
    
    @IBAction func practiceBtnTapped(_ sender: Any) {
        let mainTabBar = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBarViewController
        
        self.navigationController?.pushViewController(mainTabBar, animated: true)
    }
    @IBAction func testNowBtnTapped(_ sender: Any) {
       
        //WASIQ
//        recordingScreen.data =
         //let recordingScreen = self.storyboard?.instantiateViewController(withIdentifier: "RecordingScreen") as! RecordingScreenViewController
//        recordingScreen.data = ["title" : "Individual Wealth" as AnyObject,
//                          "part" : "Part - 1" as AnyObject,
//                          "topics" : [
//                            "Are there many wealthy people in your country?",
//                            "How did they become so wealthy?",
//                            "If you were wealthy, how would your life change?",
//                            "Can wealth sometimes lead to unhapiness? How?"
//                            ] as AnyObject,
//                          "topicTitle" : "Individual Wealth"
//            ] as [String:AnyObject]
        //END WASIQ
        
    
        //RUTTAB
        SVProgressHUD.show(withStatus: "Loading")
        ref = Database.database().reference()
        
        getOneRandomQuestionFromDB { [weak self] status in
            if status == true {
                
                guard let weakSelf = self else {return}
                
                print(weakSelf.data)
                SVProgressHUD.dismiss()
                let recordingScreen = weakSelf.storyboard?.instantiateViewController(withIdentifier: "TestRecordingScreen") as! TestRecordingScreenViewController
              //  recordingScreen.data =  weakSelf.data
                let sortedResults = (weakSelf.data as NSArray).sortedArray(using: [NSSortDescriptor(key: "part", ascending: true)]) as! [[String:AnyObject]]
                
                if !recordingScreen.questionsWithMultipleParts.isEmpty {
                    recordingScreen.questionsWithMultipleParts.removeAll()
                }
                
                recordingScreen.questionsWithMultipleParts = sortedResults
                recordingScreen.isTestNow = true
                weakSelf.navigationController?.pushViewController(recordingScreen, animated: true)
            } else {
                SVProgressHUD.dismiss()
            }
        }
        //END RUTTAB
    }
}


//RUTTAB
extension FirstViewController {
    func getOneRandomQuestionFromDB(completion: @escaping ((Bool) -> Void)) {
    
        let randomNumber = Int.random(in: 0..<self.questionsArray.count)
        self.selectedQuestion = questionsArray[randomNumber]
        
        self.ref.child("Questions/" + self.selectedQuestion).observeSingleEvent(of: .value) { (snapshot) in
            
            let JSON = snapshot.value as! [String: AnyObject]
            
            self.data = Array<Dictionary<String,AnyObject>>()
            
            for index in JSON {
                let maintitle = index.key
                let content = index.value
                var image = ""
                
                if content is String {
                    continue
                }
                
                for parts in index.value as! [String: AnyObject] {
                    if parts.key == "image" {
                        image = parts.value as! String
                    } else {

                        let partkey = parts.key // Part - 1

                        let partcontent = parts.value as! [String]
                        let dictionary = ["title" : self.selectedQuestion,
                                          "part" : maintitle,
                                          "topics" : partcontent,
                                          "topicTitle" : partkey
                            ] as [String:AnyObject]
                        self.data.append(dictionary)
                        break
                    }
                }
            }
            completion(true)
        }
        
        
//        //get a list of all questions in db and add them in an array
//        ref.child("Questions").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
//            let JSON = snapshot.value as! [String: AnyObject]
//
//            var questionsInDB = [String]()
//            let randomNumber = Int.random(in: 0..<self.questionsArray.count)
//
//            for index in JSON {
//                questionsInDB.append(index.key)
//            }
//
//            //select a question at random from the array
//            self.selectedQuestion = questionsInDB[randomNumber]
//
//            //get data for that randomly selected question
//            self.ref.child("Questions/" + self.selectedQuestion).observeSingleEvent(of: .value) { (snapshot) in
//                let JSON = snapshot.value as! [String: AnyObject]
//                for index in JSON {
//                    let maintitle = index.key
//                    let content = index.value
//                    var image = ""
//
//                    if content is String {
//                        continue
//                    }
//
//                    for parts in index.value as! [String: AnyObject] {
//                        if parts.key == "image" {
//                            image = parts.value as! String
//                        } else {
//
//                            let partkey = parts.key // Part - 1
//
//                            let partcontent = parts.value as! [String]
//
//                            self.data = ["title" : self.selectedQuestion,
//                                         "part" : maintitle,
//                                         "topics" : partcontent,
//                                         "topicTitle" : partkey
//                                    ] as [String:AnyObject]
//                        }
//                    }
//                }
//                completion(true)
//            }
//
//        }
        
//        let selectedQuestion = questionsInDB[randomNumber]
//
//        ref.child("Questions").queryEqual(toValue: selectedQuestion).observeSingleEvent(of: .value) { (snapshot) in
//            let JSON = snapshot.value as! [String: AnyObject]
//            print(JSON)
//        }
        
//        let number = Int.random(in: 0 ..< noOfQuestionsInDB)
//        ref.child("Questions").observeSingleEvent(of: .value) { (snapshot) in
//            let JSON = snapshot.value as! [String: AnyObject]
//            for index in JSON {
//                let maintitle = index.key
//                var image = ""
//
//                let content = index.value
//
//                for parts in content as! [String:AnyObject] {
//                    if parts.key == "image" {
//                        image = parts.value as! String
//                    } else {
//                        var sectionarray = Array<Dictionary<String, AnyObject>>()
//                        var sectiondictionary = Dictionary<String, AnyObject>()
//                        let partkey = parts.key // Part - 1
//                        let partcontent = parts.value as! [String:AnyObject]
//
//                        for p in partcontent {
//                            sectiondictionary["title"] = p.key as AnyObject
//                            sectiondictionary["selected"] = false as AnyObject
//                            sectiondictionary["content"] = p.value
//                            sectionarray.append(sectiondictionary)
//                        }
//                        self.sections.append(Sections(image: image, title: partkey, items: sectionarray, expanded: false))
//                    }
//                }
//                self.menu.append(Questions(maintitle: maintitle, image: image, section: self.sections))
//                self.sections.removeAll()
//
//                print("Items inside menu", self.menu.count)
//            }
//            DispatchQueue.main.async {
//                SVProgressHUD.dismiss()
//            }
//        }
    }
}
//END RUTTAB
