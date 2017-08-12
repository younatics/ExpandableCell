//
//  ExpandableTableView.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableTableView: UITableView {
    public var animation: UITableViewRowAnimation = .top
    public var expandableStyle: ExpandableStyle = .closeAndOpen
    
    fileprivate var expandableProcessor = ExpandableProcessor()
    fileprivate var formerIndexPath: IndexPath?

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
        
        if !expandableProcessor.isExpandedCell(at: indexPath) {
            delegate.expandableTableView(self, didSelectRowAt: indexPath)
            if expandableProcessor.isExpandable(at: indexPath) {
                if expandableStyle == .closeAndOpen {
                    let closedIndexPaths = closeAllIndexPaths()
                    var count = 0
                    for closedIndexPath in closedIndexPaths {
                        if closedIndexPath.section == indexPath.section && closedIndexPath.row < indexPath.row {
                            count += 1
                        }
                    }
                    print(IndexPath(row: indexPath.row - count, section: indexPath.section))
                    open(indexPath: IndexPath(row: indexPath.row - count, section: indexPath.section), delegate: delegate)
                } else if expandableStyle == .normal {
                    open(indexPath: indexPath, delegate: delegate)
                }
            } else {
                close(indexPath: indexPath)
                formerIndexPath = nil
            }
        } else {
            delegate.expandableTableView(self, didSelectExpandedRowAt: indexPath)
        }
    }
    
    private func open(indexPath: IndexPath, delegate: ExpandableDelegate) {
        let originalIndexPath = expandableProcessor.original(indexPath: indexPath)
        guard let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: originalIndexPath) else { return }
        guard let expandedHeights = delegate.expandableTableView(self, heightsForExpandedRowAt: originalIndexPath) else { return }
        
        expandableProcessor.insert(indexPath: indexPath, expandedCells: expandedCells, expandedHeights: expandedHeights)
        self.insertRows(at: expandableProcessor.indexPathsWhere(indexPath: indexPath), with: animation)

        guard let cell = self.cellForRow(at: indexPath) as? ExpandableCell else { return }
        cell.open()
    }
    
    private func close(indexPath: IndexPath) {
        expandableProcessor.delete(indexPath: indexPath)
        guard let indexPaths = closeIndexPaths(indexPath: indexPath) else { return }
        self.deleteRows(at: indexPaths, with: animation)
        
        guard let cell = self.cellForRow(at: indexPath) as? ExpandableCell else { return }
        cell.close()

    }
    
    private func closeIndexPaths(indexPath: IndexPath) -> [IndexPath]? {
        guard let indexPaths = expandableProcessor.willRemovedIndexPaths else { return nil }
        
        return indexPaths
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
    public func openAll() {
        var indexPaths = [IndexPath]()
        
        guard let delegate = expandableDelegate else { return }
        
        let section = self.numberOfSections(in: self)
        for sectionNum in 0..<section {
            let row = self.numberOfRows(inSection: sectionNum)
            for rowNum in 0..<row {
                let indexPath = IndexPath(row: rowNum, section: sectionNum)
                
                if let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: indexPath), let expandedHeights = delegate.expandableTableView(self, heightsForExpandedRowAt: indexPath) {
                    expandableProcessor.insert(indexPath: indexPath, expandedCells: expandedCells, expandedHeights: expandedHeights)
                    
                    indexPaths += expandableProcessor.indexPathsWhere(indexPath: indexPath)
                    self.insertRows(at: expandableProcessor.indexPathsWhere(indexPath: indexPath), with: animation)

                    if let cell = self.cellForRow(at: indexPath) as? ExpandableCell {
                        cell.open()
                    }
                }
            }
        }
        
        print(expandableProcessor.expandableDatas)
        
    }
    
    public func closeAll() {
        _ = closeAllIndexPaths()
    }
    
    public func closeAllIndexPaths() -> [IndexPath] {
        let allIndexPaths = expandableProcessor.deleteAllIndexPaths()
        let expandedIndexPaths = allIndexPaths.expandedIndexPaths
        let indexPaths = allIndexPaths.indexPaths
        
        for indexPath in indexPaths {
            if let cell = self.cellForRow(at: indexPath) as? ExpandableCell {
                cell.close()
            }
        }

        self.deleteRows(at: expandedIndexPaths, with: animation)
        return indexPaths
    }
    
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
