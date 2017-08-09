//
//  ExpandableData.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 8..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

struct ExpandableData {
    var clickedIndexPath: IndexPath
    var expandedCells: [UITableViewCell]
    var expandedIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        for i in 0..<expandedCells.count {
            let indexPath = IndexPath(row: clickedIndexPath.row + i + 1 , section: clickedIndexPath.section)
            indexPaths.append(indexPath)
        }
        print(indexPaths)
        return indexPaths
    }
    var expandedCellCount: Int {
        return expandedCells.count
    }
}

class ExpandableProcessor {
    var expandableData = [ExpandableData]()
    
    func append(indexPath: IndexPath, expandedCells: [UITableViewCell]) {
        expandableData.append(ExpandableData(clickedIndexPath: indexPath, expandedCells: expandedCells))
    }
    
    func indexPathsWhere(indexPath: IndexPath) -> [IndexPath] {
        let filteredExpandedDatas = expandableData.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath == indexPath)
        })
        
        if filteredExpandedDatas.count > 1 {
            fatalError("Somwthing Wrong")
        }
        return filteredExpandedDatas[0].expandedIndexPaths
    }
    
    func numberOfExpandedRowsInSection(section: Int) -> Int {
        var count = 0
        let filteredExpandedDatas = expandableData.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath.section == section)
        })
        
        for filteredExpandedData in filteredExpandedDatas {
            count += filteredExpandedData.expandedCellCount
        }
        return count
    }
    
    func indexPathBeforeExpand(indexPath: IndexPath) -> IndexPath {
        let filteredExpandedDatas = expandableData.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath.section == indexPath.section) && (expandedData.expandedCellCount >= indexPath.row) && (expandedData.clickedIndexPath.row < indexPath.row)
        })
        if filteredExpandedDatas.count > 1 {
            fatalError("Somwthing Wrong")
        } else if filteredExpandedDatas.count == 1 {
            return filteredExpandedDatas[0].indexPath
        } else {
            return indexPath
        }
    }
    
    func expandedCell(at indexPath: IndexPath) -> UITableViewCell? {
        let filteredExpandedDatas = expandableData.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath.section == indexPath.section) && (expandedData.expandedCellCount >= indexPath.row) && (expandedData.clickedIndexPath.row < indexPath.row)
        })
        
        if filteredExpandedDatas.count > 0 {
            let filteredExpandedData = filteredExpandedDatas[0]
            
            for i in 1..<filteredExpandedData.expandedCellCount + 1{
                if filteredExpandedData.indexPath.row + i == indexPath.row {
                    return filteredExpandedData.expandedCells[i-1]
                }
            }
        }
        
//        print(filteredExpandedDatas)
        return nil
    }
    
}

