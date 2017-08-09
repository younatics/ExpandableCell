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
    @IBOutlet weak var tableView: ExpandableTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.expandableDelegate = self
        tableView.register(UINib(nibName: "ExpandableNormalCell", bundle: nil), forCellReuseIdentifier: ExpandableNormalCell.ID)
        tableView.register(UINib(nibName: "ExpandableExpandedCell", bundle: nil), forCellReuseIdentifier: ExpandableExpandedCell.ID)
        tableView.register(UINib(nibName: "ExpandableExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableExpandableCell.ID)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: ExpandableDelegate {
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableExpandedCell.ID) as? ExpandableCell else { return [UITableViewCell]() }
                var cells = [UITableViewCell]()
                cells.append(cell)
                cells.append(cell)
                return cells
                
            case 2, 3:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableExpandedCell.ID) as? ExpandableCell else { return [UITableViewCell]() }
                var cells = [UITableViewCell]()
                cells.append(cell)
                cells.append(cell)
                return cells
                
            default:
                break
            }
        default:
            break
        }
        return nil
    }

    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 2
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath, expandableCellStyle: ExpandableCellStyle, isExpanded: Bool) {
//        print("didSelectRow:\(indexPath) expandableCellStyle: \(expandableCellStyle), isExpanded: \(isExpanded)")
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> ExpandableCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0, 1, 4:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableExpandableCell.ID) as? ExpandableCell else { return ExpandableCell() }
                return cell
                
            case 2, 3:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableNormalCell.ID) as? ExpandableCell else { return ExpandableCell() }
                return cell

            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 1, 2:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableExpandableCell.ID) as? ExpandableCell else { return ExpandableCell() }
                return cell
                
            case 0, 3, 4:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableNormalCell.ID) as? ExpandableCell else { return ExpandableCell() }
                return cell
                
            default:
                break
            }
        default:
            break
        }
        
        return ExpandableCell()
    }
    
}
