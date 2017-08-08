//
//  ExpandableTableView.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableTableView: UITableView {
    public var expandableDelegate: ExpandableDelegate? {
        didSet {
            self.dataSource = self
            self.delegate = self
        }
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
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
            for
            self.insertRows(at: expandedCells, with: .top)
        }
        
        delegate.expandableTableView(self, didSelectRowAt: indexPath, expandableCellStyle: .normal, isExpanded: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let delegate = expandableDelegate else { return 0 }
        
        let count = delegate.expandableTableView(self, numberOfRowsInSection: section)
        
        return count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = expandableDelegate else { return UITableViewCell() }
        let cell = delegate.expandableTableView(self, cellForRowAt: indexPath)
        
        return cell
    }

    
}
