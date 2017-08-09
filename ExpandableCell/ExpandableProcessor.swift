//
//  ExpandableData.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 8..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

struct ExpandableData {
    var indexPath: IndexPath
    var expandedCells: [UITableViewCell]
    var expandedCellCount: Int {
        return expandedCells.count
    }
    
    var maximumIndexPath: IndexPath {
        return IndexPath(row: indexPath.row + expandedCellCount, section: indexPath.section)
    }
    
    func expandedCell(index: Int) -> UITableViewCell {
        return expandedCells[index]
    }
}

class ExpandableProcessor {
    var expandableData = [ExpandableData]()
    
    func append(indexPath: IndexPath, expandedCells: [UITableViewCell]) {
        expandableData.append(ExpandableData(indexPath: indexPath, expandedCells: expandedCells))
    }
    
    func indexPathsWhere(indexPath: IndexPath) -> [IndexPath] {
        guard let foo = expandableData.enumerated().first(where: {$0.element.indexPath == indexPath}) else { return [IndexPath]() }
        let count = foo.element.expandedCellCount
        
        var indexPaths = [IndexPath]()
        for i in 0..<count {
            let tempIndexPath = IndexPath(row: indexPath.row + i + 1, section: indexPath.section)
            indexPaths.append(tempIndexPath)
        }
        
        return indexPaths
    }
    
    func numberOfExpandedRowsInSection(section: Int) -> Int {
        var count = 0
        let filteredExpandedDatas = expandableData.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.indexPath.section == section)
        })
        
        for filteredExpandedData in filteredExpandedDatas {
            count += filteredExpandedData.expandedCellCount
        }
        return count
    }
    
    func indexPathBeforeExpand(indexPath: IndexPath) -> IndexPath {
        var count = 0
        let filteredExpandedDatas = expandableData.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.indexPath.section == indexPath.section) && (expandedData.indexPath.row < indexPath.row)
        })
        
        for filteredExpandedData in filteredExpandedDatas {
            count += filteredExpandedData.expandedCellCount
        }

        return IndexPath(row: indexPath.row - count, section: indexPath.section)
    }
    
    func expandedCell(at indexPath: IndexPath) -> UITableViewCell {
        let filteredExpandedDatas = expandableData.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.indexPath.section == indexPath.section) && (expandedData.indexPath.row > indexPath.row) && (expandedData.expandedCellCount < indexPath.row)
        })
        
        print(filteredExpandedDatas)
        return UITableViewCell()
    }
    
}

