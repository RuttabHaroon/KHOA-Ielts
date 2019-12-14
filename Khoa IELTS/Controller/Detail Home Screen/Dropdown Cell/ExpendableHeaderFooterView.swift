//
//  ExpendableHeaderFooterView.swift
//  Khoa IELTS
//
//  Created by ColWorx on 02/01/2019.
//  Copyright © 2019 ast. All rights reserved.
//

import UIKit

protocol  ExpandableHeaderFooterViewDelegate {
    func toggleSection(header: ExpandableHeaderFooterView, section: Int)
}
class ExpandableHeaderFooterView: UITableViewHeaderFooterView {
    
    var delegate : ExpandableHeaderFooterViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderFooterView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func customInit(title: String, section: Int, delegate: ExpandableHeaderFooterViewDelegate) -> String{
        self.section = section
        self.delegate = delegate
        
        return title
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = UIColor.white
    }
}
