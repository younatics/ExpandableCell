//
//  ViewController.swift
//  ExpandableCellDemo
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit
import ExpandableCell

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = ExpandableTableView()
        tableView.expandableDelegate = self
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: ExpandableDelegate {
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath, expandableCellStyle: ExpandableCellStyle, isExpanded: Bool) {
        print()
    }
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> ExpandableCell {
        return ExpandableCell()
    }
    
}
