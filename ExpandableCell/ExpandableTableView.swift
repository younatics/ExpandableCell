//
//  ExpandableTableView.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableTableView: UITableView {
    fileprivate var expandableData = ExpandableData()

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
        
        let cell = delegate.expandableTableView(self, cellForRowAt: indexPath)
        if cell.style == .expandable && !cell.isExpanded {
            let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: indexPath)
            expandableData.append(indexPath: indexPath, expandedCells: expandedCells)
            
            self.insertRows(at: expandableData.indexPathsWhere(indexPath: indexPath), with: .top)
        }
        
        delegate.expandableTableView(self, didSelectRowAt: indexPath, expandableCellStyle: .normal, isExpanded: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let delegate = expandableDelegate else { return 0 }
        
        return delegate.expandableTableView(self, numberOfRowsInSection: section) + delegate.expandableTableView(self, numberOfExpandedRowsInSection: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = expandableDelegate else { return UITableViewCell() }
        let cell = delegate.expandableTableView(self, cellForRowAt: indexPath)
        
        return cell
    }

    
}
