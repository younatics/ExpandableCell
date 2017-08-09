//
//  ExpandableTableView.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableTableView: UITableView {
    fileprivate var expandableProcessor = ExpandableProcessor()

    public var expandableDelegate: ExpandableDelegate? {
        didSet {
            self.dataSource = self
            self.delegate = self
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        initTableView()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initTableView()
    }
    
    func initTableView() {
//        expandableData = ExpandableData()
    }
}

extension ExpandableTableView: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let delegate = expandableDelegate else { return 0 }
        
        return delegate.numberOfSections(in: self)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = expandableDelegate else { return }
        
        let indexPathBeforeExpand = expandableProcessor.indexPathBeforeExpand(indexPath: indexPath)
        print(indexPathBeforeExpand)

        let cell = delegate.expandableTableView(self, cellForRowAt: indexPathBeforeExpand)
        if !cell.isExpanded {
            if let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: indexPathBeforeExpand) {
                expandableProcessor.append(indexPath: indexPath, expandedCells: expandedCells)
                self.insertRows(at: expandableProcessor.indexPathsWhere(indexPath: indexPath), with: .top)
                cell.isExpanded = true
            }
        }
        
        delegate.expandableTableView(self, didSelectRowAt: indexPath, expandableCellStyle: cell.style, isExpanded: cell.isExpanded)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let delegate = expandableDelegate else { return 0 }
        
        return delegate.expandableTableView(self, numberOfRowsInSection: section) + expandableProcessor.numberOfExpandedRowsInSection(section: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = expandableDelegate else { return UITableViewCell() }
        
        let indexPathBeforeExpand = expandableProcessor.indexPathBeforeExpand(indexPath: indexPath)
        
//        print(indexPath)
//        print(indexPathBeforeExpand)

//        let cell = delegate.expandableTableView(self, cellForRowAt: indexPathBeforeExpand)
        if let cell = expandableProcessor.expandedCell(at: indexPath) {
            return cell
        } else {
            let cell = delegate.expandableTableView(self, cellForRowAt: indexPath)
            return cell
        }
//        print("cellForRowAt: \(indexPath), style: \(cell.style), isExpanded: \(cell.isExpanded)")
//        if cell.isSelected == true {
        
//        }
        return UITableViewCell()
    }

    
}
