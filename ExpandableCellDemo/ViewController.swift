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
        tableView.register(UINib(nibName: "NormalCell", bundle: nil), forCellReuseIdentifier: NormalCell.ID)
        tableView.register(UINib(nibName: "ExpandedCell", bundle: nil), forCellReuseIdentifier: ExpandedCell.ID)
        tableView.register(UINib(nibName: "ExpandableCell", bundle: nil), forCellReuseIdentifier: ExpandableCell.ID)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: ExpandableDelegate {
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) else { return [UITableViewCell]() }
        guard let cell2 = expandableTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) else { return [UITableViewCell]() }
        guard let cell3 = expandableTableView.dequeueReusableCell(withIdentifier: ExpandedCell.ID) else { return [UITableViewCell]() }

        var cells = [UITableViewCell]()

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cells.append(cell)
                cells.append(cell2)
                cells.append(cell3)
                return cells
                
            case 2:
                cells.append(cell)
                cells.append(cell2)
                return cells
            case 3:
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
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        var heights = [CGFloat]()

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let height: CGFloat = 44
                heights.append(height)
                heights.append(height)
                heights.append(height)
                return heights
                
            case 2:
                let height: CGFloat = 33
                heights.append(height)
                heights.append(height)
                return heights
                
            case 3:
                let height: CGFloat = 22
                heights.append(height)
                return heights

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

    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRow:\(indexPath)")
    }
    
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0, 2, 3:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ExpandableCell.ID) else { return UITableViewCell() }
                return cell
                
            case 1, 4:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: NormalCell.ID)  else { return UITableViewCell() }
                return cell

            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0, 1, 2, 3, 4:
                guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: NormalCell.ID) else { return UITableViewCell() }
                return cell
                
            default:
                break
            }
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0, 2, 3:
                return 66
                
            case 1, 4:
                return 55
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0, 1, 2, 3, 4:
                return 55
                
            default:
                break
            }
        default:
            break
        }
        
        return 44
    }
}
