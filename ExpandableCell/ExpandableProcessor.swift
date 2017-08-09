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
        print("expandedIndexPaths: \(expandedIndexPaths)")
        return indexPaths
    }
    var expandedCellCount: Int {
        return expandedCells.count
    }
}

class ExpandableProcessor {
    var expandableDatas = [ExpandableData]()
    
    func append(indexPath: IndexPath, expandedCells: [UITableViewCell]) {
        expandableDatas.append(ExpandableData(clickedIndexPath: indexPath, expandedCells: expandedCells))
    }
    
    func indexPathsWhere(indexPath: IndexPath) -> [IndexPath] {
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath == indexPath)
        })
        
        if filteredExpandedDatas.count > 1 {
            fatalError("Somwthing Wrong")
        }
        return filteredExpandedDatas[0].expandedIndexPaths
    }
    
    func numberOfExpandedRowsInSection(section: Int) -> Int {
        var count = 0
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath.section == section)
        })
        
        for filteredExpandedData in filteredExpandedDatas {
            count += filteredExpandedData.expandedCellCount
        }
        return count
    }
    
    func original(indexPath: IndexPath) -> IndexPath {
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath.section == indexPath.section) && (expandedData.clickedIndexPath.row + expandedData.expandedCellCount < indexPath.row)
        })
        var count = 0
        for filteredExpandedData in filteredExpandedDatas {
            count += filteredExpandedData.expandedCellCount
        }
//        print("original: \(IndexPath(row: indexPath.row - count, section: indexPath.section))")
        return IndexPath(row: indexPath.row - count, section: indexPath.section)
    }
    
    func expandedCell(at indexPath: IndexPath) -> UITableViewCell? {
        let originalIndexPath = original(indexPath: indexPath)
        
        for expandableData in expandableDatas {
            if let index = expandableData.expandedIndexPaths.index(of: originalIndexPath) {
                return expandableData.expandedCells[index]
            }
        }
        
        print("expandedCell indexPath: \(indexPath)")
        print("expandedCell originalIndexPath: \(originalIndexPath)")

//        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
//            return (expandedData.clickedIndexPath.section == originalIndexPath.section)
//        })
//        
//        print(filteredExpandedDatas)
//        
//        if filteredExpandedDatas.count > 0 {
//            let filteredExpandedData = filteredExpandedDatas[0]
//            
//            for i in 1..<filteredExpandedData.expandedCellCount + 1 {
//                if filteredExpandedData.clickedIndexPath.row + i == indexPath.row {
//                    return filteredExpandedData.expandedCells[i-1]
//                }
//            }
//        }
        return nil
    }
    
}

