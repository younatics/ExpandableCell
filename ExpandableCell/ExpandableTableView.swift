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
        tableView.deselectRow(at: indexPath, animated: true)
        guard let delegate = expandableDelegate else { return }
        
        let originalIndexPath = expandableProcessor.original(indexPath: indexPath)

        guard let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: originalIndexPath) else { return }
        guard !expandableProcessor.isExpandedCell(at: indexPath) else { return }
        
        if expandableProcessor.isExpandable(at: indexPath) {
            expandableProcessor.insert(indexPath: indexPath, expandedCells: expandedCells)
            self.insertRows(at: expandableProcessor.indexPathsWhere(indexPath: indexPath), with: .top)
        } else {
            expandableProcessor.delete(indexPath: indexPath)
            guard let indexPaths = expandableProcessor.willRemovedIndexPaths else { return }
            self.deleteRows(at: indexPaths, with: .top)
        }
        
        delegate.expandableTableView(self, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let delegate = expandableDelegate else { return 0 }
        
        return delegate.expandableTableView(self, numberOfRowsInSection: section) + expandableProcessor.numberOfExpandedRowsInSection(section: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = expandableDelegate else { return UITableViewCell() }
        
        if let cell = expandableProcessor.expandedCell(at: indexPath) {
            return cell
        } else {
            let cell = delegate.expandableTableView(self, cellForRowAt: indexPath)
            return cell
        }
    }
}
