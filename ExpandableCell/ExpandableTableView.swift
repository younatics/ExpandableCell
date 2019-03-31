//
//  ExpandableTableView.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableTableView: UITableView {
    public var animation: UITableView.RowAnimation = .top
    public var expansionStyle: ExpandableTableView.ExpansionStyle = .multi
    public var autoReleaseDelegate: Bool = true
    public var autoRemoveSelection: Bool = true
    fileprivate var expandableProcessor = ExpandableProcessor()
    fileprivate var formerIndexPath: IndexPath?

    public var expandableDelegate: ExpandableDelegate? {
        didSet {
            self.dataSource = self
            self.delegate = self
        }
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil && self.autoReleaseDelegate {
            self.expandableDelegate = nil
        }
    }
}

extension ExpandableTableView {
    public enum ExpansionStyle {
        case multi
        case single
        case singlePerSection
    }
}

// MARK: Required methods
extension ExpandableTableView: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard let delegate = expandableDelegate else { return 0 }
        return delegate.numberOfSections(in: self)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let delegate = expandableDelegate else { return }
        
        let expandedData = expandableProcessor.isExpandedCell(at: indexPath)
        
        //unhighlight cell if it is not selectable
        //other types of selection will be handled directly by the underlined
        //tableview selectionStyle
        let allowsSelection = self.allowsSelection || self.allowsMultipleSelection
        if !expandableProcessor.isSelectable(at: indexPath, defaultValue: allowsSelection) || self.autoRemoveSelection {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if !expandedData.isExpandedCell {
            delegate.expandableTableView(self, didSelectRowAt: indexPath)
            
            handleRowExpansion(at: indexPath)
        } else {
            delegate.expandableTableView(self, didSelectExpandedRowAt: indexPath)
            delegate.expandableTableView(self, expandedCell: expandedData.expandedCell, didSelectExpandedRowAt: indexPath)
        }
    }
    
    fileprivate func handleRowExpansion(at indexPath: IndexPath) {
        guard let delegate = expandableDelegate else { return }

        if expandableProcessor.isExpandable(at: indexPath) {
            
            // Check if there are other rows expanded in section
            let noExpandedRowsInSection = expandableProcessor.numberOfExpandedRowsInSection(section: indexPath.section) == 0
            
            if let cell = self.cellForRow(at: indexPath) {
                if self.expansionStyle == .single {
                    closeAll()
                } else if self.expansionStyle == .singlePerSection && !noExpandedRowsInSection {
                    closeAllInSection(indexPath.section)
                }
                if let correctIndexPath = self.indexPath(for: cell) {
                    // If no other row is expanded in section
                    if noExpandedRowsInSection {
                        let originalIndexPath = expandableProcessor.original(indexPath: correctIndexPath)
                        open(indexPath: originalIndexPath, delegate: delegate)
                    } else {
                        open(indexPath: correctIndexPath, delegate: delegate)
                    }
                }
            }
        } else {
            close(indexPath: indexPath)
            formerIndexPath = nil
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        //Intially expanded rows can only be expanded on the first load of the
        //cell into the table view, after that they are ignored
        self.openAllInitiallyExpanded()
    }
    
    fileprivate func open(indexPath: IndexPath, delegate: ExpandableDelegate) {
        let originalIndexPath = expandableProcessor.original(indexPath: indexPath)
        guard let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: originalIndexPath) else { return }
        guard let expandedHeights = delegate.expandableTableView(self, heightsForExpandedRowAt: originalIndexPath) else { return }
        var isSelectable = false
        if let cell = self.cellForRow(at: indexPath) as? ExpandableCell {
            isSelectable = cell.isSelectable()
        }
        
        guard expandableProcessor.insert(indexPath: indexPath, expandedCells: expandedCells, expandedHeights: expandedHeights, isExpandCellSelectable: isSelectable) else { return }
        
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
        guard let delegate = expandableDelegate else { return UITableView.automaticDimension }
        let originalIndexPath = expandableProcessor.original(indexPath: indexPath)

        if let height = expandableProcessor.expandedHeight(at: indexPath) {
            return height
        } else {
            let height = delegate.expandableTableView(self, heightForRowAt: originalIndexPath)
            return height
        }
    }
    
// Mark: Optional forward ScrollView methods
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        expandableDelegate?.scrollViewDidScroll?(scrollView)
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        expandableDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        expandableDelegate?.scrollViewDidZoom?(scrollView)
    }
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        expandableDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        expandableDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        expandableDelegate?.scrollViewWillBeginDragging?(scrollView)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        expandableDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        expandableDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity:velocity, targetContentOffset: targetContentOffset)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        expandableDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        expandableDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        expandableDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }
    
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return expandableDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? false
    }
    
    @available(iOS 11.0, *)
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        expandableDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}

// MARK: Optional methods
extension ExpandableTableView {
	public func openAll() {
		guard let delegate = expandableDelegate else { return }
		
		var rowCountInSections = [(rowCount:Int, section: Int)]()
		let sections = delegate.numberOfSections(in: self)
		
		for sectionNum in 0..<sections {
			var rows = delegate.expandableTableView(self, numberOfRowsInSection: sectionNum)
			for rowNum in 0..<rows {
				let indexPath = IndexPath(row: rowNum, section: sectionNum)
				if let expandedCells = delegate.expandableTableView(self, expandedCellsForRowAt: indexPath) {
					rows += expandedCells.count
				}
			}
			rowCountInSections.append((rows, sectionNum))
		}
		
		for rowCountInSection in rowCountInSections {
			for row in 0..<rowCountInSection.rowCount {
                open(at: IndexPath(row: row, section: rowCountInSection.section))
			}
		}
	}
    
    func openAllInitiallyExpanded() {
        guard let delegate = expandableDelegate else { return }

        var rowsToExpand = [IndexPath]()
        let sections = delegate.numberOfSections(in: self)

        for sectionNum in 0..<sections {
            let rows = delegate.expandableTableView(self, numberOfRowsInSection: sectionNum)
            for rowNum in 0..<rows {
                let indexPath = IndexPath(row: rowNum, section: sectionNum)
                if let cell = self.cellForRow(at: indexPath) as? ExpandableCell {
                    if cell.isInitiallyExpandedInternal() {
                        rowsToExpand.append(indexPath)
                    }
                }
            }
        }
        
        for indexPath in rowsToExpand {
            open(at: indexPath)
        }
    }
	
    public func open(at indexPath: IndexPath) {
		guard let delegate = expandableDelegate else { return }
		
		let expandedData = expandableProcessor.isExpandedCell(at: indexPath)
		if !expandedData.isExpandedCell && expandableProcessor.isExpandable(at: indexPath) {
			open(indexPath: indexPath, delegate: delegate)
		}
	}
    
    public func reloadExpandableExpandedCells(at indexPaths: [IndexPath]) {
        guard let delegate = expandableDelegate else { return }

        var originalCells = [ExpandableCell]()
        indexPaths.forEach { (indexPath) in
            if let cell = delegate.expandableTableView(self, cellForRowAt: indexPath) as? ExpandableCell {
                originalCells.append(cell)
            }
        }
        self.reloadExpandableExpandedCells(originalCells)
    }
    
    public func reloadExpandableExpandedCells(_ cells: [ExpandableCell]) {
        cells.forEach { (cell) in
            if let currentIndexPath = self.indexPath(for: cell) {
                if cell.isExpanded() {
                    close(at: currentIndexPath)
                    if let newIndexPath = self.indexPath(for: cell) {
                        open(at: newIndexPath)
                    }
                }
            }
        }
    }

    public func closeAll() {
        _ = closeAllIndexPaths()
    }
    
    public func closeAllInSection(_ section: Int) {
        _ = closeAllIndexPathsInSection(section)
    }
    
    public func closeAllIndexPathsInSection(_ section: Int) -> [IndexPath] {
        let allIndexPaths = expandableProcessor.deleteAllIndexPathsInSection(section)
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
    
    public func close(at indexPath: IndexPath) {
        guard let cell = self.cellForRow(at: indexPath) as? ExpandableCell else { return }
        if cell.isExpanded() {
            close(indexPath: indexPath)
        }
    }
    
    open override func reloadData() {
        if let delegate = expandableDelegate {
            for i in 0..<expandableProcessor.expandableDatasPerSection.count {
                guard var expandableDatas = expandableProcessor.expandableDatasPerSection[i] else { continue }
                for j in 0..<expandableDatas.count {
                    guard let cells = delegate.expandableTableView(self, expandedCellsForRowAt: expandableDatas[j].originalIndexPath) else { return }
                    expandableDatas[j].expandedCells = cells
                }
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
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let delegate = expandableDelegate else { return 0 }
        return delegate.expandableTableView(self, heightForFooterInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let delegate = expandableDelegate else { return nil }
        return delegate.expandableTableView(self, viewForFooterInSection: section)
    }
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let delegate = expandableDelegate else { return nil }
        return delegate.expandableTableView(self, titleForFooterInSection: section)
    }
    
    @objc(tableView:willDisplayCell:forRowAtIndexPath:) public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = expandableDelegate else { return }
        delegate.expandableTableView(self, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = expandableDelegate else { return }

        delegate.expandableTableView(self, didEndDisplaying: cell, forRow: indexPath)
      
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
         guard let delegate = expandableDelegate else { return false }
        return delegate.expandableTableView(self, shouldHighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let delegate = expandableDelegate else { return }
        return delegate.expandableTableView(self, didHighlightRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let delegate = expandableDelegate else { return }
        return delegate.expandableTableView(self, didUnhighlightRowAt: indexPath)
    }
}
