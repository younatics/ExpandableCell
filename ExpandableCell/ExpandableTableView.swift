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
        
        let expandedData = expandableProcessor.isExpandedCell(at: indexPath)
        if !expandedData.isExpandedCell {
            delegate.expandableTableView(self, didSelectRowAt: indexPath)
            if expandableProcessor.isExpandable(at: indexPath) {
                open(indexPath: indexPath, delegate: delegate)
            } else {
                close(indexPath: indexPath)
                formerIndexPath = nil
            }
        } else {
            delegate.expandableTableView(self, didSelectExpandedRowAt: indexPath)
            delegate.expandableTableView(self, expandedCell: expandedData.expandedCell, didSelectExpandedRowAt: indexPath)
        }
    }
    
    fileprivate func open(indexPath: IndexPath, delegate: ExpandableDelegate) {
        let originalIndexPath = expandableProcessor.original(indexPath: indexPath)
        guard let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: originalIndexPath) else { return }
        guard let expandedHeights = delegate.expandableTableView(self, heightsForExpandedRowAt: originalIndexPath) else { return }
        guard expandableProcessor.insert(indexPath: indexPath, expandedCells: expandedCells, expandedHeights: expandedHeights) else { return }
        
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
		guard let delegate = expandableDelegate else { return }
		
		var rowCountInSections = [(rowCount:Int, section: Int)]()
		let sections = self.numberOfSections(in: self)
		
		for sectionNum in 0..<sections {
			var rows = self.numberOfRows(inSection: sectionNum)
			for rowNum in 0..<rows {
				let indexPath = IndexPath(row: rowNum, section: sectionNum)
				if let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: indexPath) {
					rows += expandedCells.count
				}
			}
			rowCountInSections.append((rows,sectionNum))
		}
		
		for rowCountInSection in rowCountInSections {
			for row in 0..<rowCountInSection.rowCount {
                open(at: IndexPath(row: row, section: rowCountInSection.section))
			}
		}
	}
	
    public func open(at indexPath: IndexPath) {
		guard let delegate = expandableDelegate else { return }
		
		let expandedData = expandableProcessor.isExpandedCell(at: indexPath)
		if !expandedData.isExpandedCell && expandableProcessor.isExpandable(at: indexPath) {
			open(indexPath: indexPath, delegate: delegate)
		}
	}

    public func closeAll() {
        _ = closeAllIndexPaths()
    }
    
    open override func reloadData() {
        if let delegate = expandableDelegate {
            for i in 0..<expandableProcessor.expandableDatas.count {
                guard let cells = delegate.expandableTableView(self, expandedCellsForRowAt: expandableProcessor.expandableDatas[i].originalIndexPath) else { return }
                expandableProcessor.expandableDatas[i].expandedCells = cells
            }
        }
        super.reloadData()
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
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = expandableDelegate else { return }
        return delegate.expandableTableView(self, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let delegate = expandableDelegate else { return }
        return delegate.expandableTableView(self, willDisplayHeaderView: view, forSection: section)
    }
    
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let delegate = expandableDelegate else { return }
        return delegate.expandableTableView(self, willDisplayFooterView: view, forSection: section)
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
         guard let delegate = expandableDelegate else
         { return false }
        return delegate.expandableTableView(self, shouldHighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let delegate = expandableDelegate else
        { return }
        return delegate.expandableTableView(self, didHighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let delegate = expandableDelegate else
        { return }
        return delegate.expandableTableView(self, didUnhighlightRowAt:indexPath)
    }
}
