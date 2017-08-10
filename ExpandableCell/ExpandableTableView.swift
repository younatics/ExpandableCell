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
}

//MARK: Required methods
extension ExpandableTableView: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let delegate = expandableDelegate else { return 0 }
        
        return delegate.numberOfSections(in: self)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let delegate = expandableDelegate else { return }
        delegate.expandableTableView(self, didSelectRowAt: indexPath)

        let originalIndexPath = expandableProcessor.original(indexPath: indexPath)

        guard let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: originalIndexPath) else { return }
        guard let expandedHeights = delegate.expandableTableView(self, heightsForExpandedRowAt: originalIndexPath) else { return }
        guard !expandableProcessor.isExpandedCell(at: indexPath) else { return }
        
        if expandableProcessor.isExpandable(at: indexPath) {
            expandableProcessor.insert(indexPath: indexPath, expandedCells: expandedCells, expandedHeights: expandedHeights)
            self.insertRows(at: expandableProcessor.indexPathsWhere(indexPath: indexPath), with: .top)
        } else {
            expandableProcessor.delete(indexPath: indexPath)
            guard let indexPaths = expandableProcessor.willRemovedIndexPaths else { return }
            self.deleteRows(at: indexPaths, with: .top)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let delegate = expandableDelegate else { return 0 }
        
        return delegate.expandableTableView(self, numberOfRowsInSection: section) + expandableProcessor.numberOfExpandedRowsInSection(section: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let delegate = expandableDelegate else { return UITableViewCell() }
        let originalIndexPath = expandableProcessor.original(indexPath: indexPath)

        if let cell = expandableProcessor.expandedCell(at: indexPath) {
            return cell
        } else {
            let cell = delegate.expandableTableView(self, cellForRowAt: originalIndexPath)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let delegate = expandableDelegate else { return 44 }
        let originalIndexPath = expandableProcessor.original(indexPath: indexPath)

        if let height = expandableProcessor.expandedHeight(at: indexPath) {
            return height
        } else {
            let height = delegate.expandableTableView(self, heightForRowAt: originalIndexPath)
            return height
        }
    }
}


//MARK: Optional methods
extension ExpandableTableView {
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let delegate = expandableDelegate else { return nil }
        return delegate.expandableTableView(self, titleForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let delegate = expandableDelegate else { return 0 }
        return delegate.expandableTableView(self, heightForHeaderInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let delegate = expandableDelegate else { return nil }
        return delegate.expandableTableView(self, viewForHeaderInSection: section)
    }
}
