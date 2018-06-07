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
    var originalIndexPath: IndexPath
    var expandedCells: [UITableViewCell]
    var expandedHeights: [CGFloat]
    
    var expandedIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        for i in 0..<expandedCells.count {
            let indexPath = IndexPath(row: self.indexPath.row + i + 1 , section: self.indexPath.section)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }
    var expandedCellCount: Int {
        return expandedCells.count
    }
}

//print("indexPath: \(expandableDatas[i].indexPath), originalIndexPath: \(expandableDatas[i].originalIndexPath), expandedIndexPaths: \(expandableDatas[i].expandedIndexPaths)")

class ExpandableProcessor {
    var expandableDatas = [ExpandableData]()
    var willRemovedIndexPaths: [IndexPath]?
    
    func insert(indexPath: IndexPath, expandedCells: [UITableViewCell], expandedHeights: [CGFloat]) -> Bool {
        for i in 0..<expandableDatas.count {
            let expandableData = expandableDatas[i]
            guard expandableData.indexPath.section == indexPath.section else { return false }
            
            if expandableData.indexPath.row > indexPath.row {
                expandableDatas[i].indexPath = IndexPath(row: expandableData.indexPath.row + expandedCells.count, section: expandableData.indexPath.section)
            }
        }
        expandableDatas.append(ExpandableData(indexPath: indexPath, originalIndexPath: original(indexPath: indexPath), expandedCells: expandedCells, expandedHeights: expandedHeights))
        return true
    }
    
    func delete(indexPath: IndexPath) {
        var deletedIndexPath = IndexPath(row: 0, section: 0)
        var deletedCellCount = 0
        
        for i in 0..<expandableDatas.count {
            if expandableDatas[i].indexPath == indexPath {
                let expandableData = expandableDatas[i]
                willRemovedIndexPaths = expandableData.expandedIndexPaths
                deletedIndexPath = expandableData.indexPath
                deletedCellCount = expandableData.expandedCellCount
                expandableDatas.remove(at: i)
                break
            }
        }
        
        for i in 0..<expandableDatas.count {
            let expandableData = expandableDatas[i]
            guard expandableData.indexPath.section == deletedIndexPath.section else { return }
            
            if expandableData.indexPath.row > deletedIndexPath.row {
                expandableDatas[i].indexPath = IndexPath(row: expandableData.indexPath.row - deletedCellCount, section: expandableData.indexPath.section)
            }
        }
    }
    
    func deleteAllIndexPaths() -> (expandedIndexPaths:[IndexPath], indexPaths: [IndexPath]) {
        var expandedIndexPaths = [IndexPath]()
        var indexPaths = [IndexPath]()
        for expandableData in expandableDatas {
            indexPaths.append(expandableData.indexPath)
            for expandedIndexPath in expandableData.expandedIndexPaths {
                expandedIndexPaths.append(expandedIndexPath)
            }
        }
        
        expandableDatas.removeAll()
        
        return (expandedIndexPaths, indexPaths)
    }
    
    func isExpandedCell(at indexPath: IndexPath) -> (isExpandedCell: Bool, expandedCell: UITableViewCell) {
        for expandableData in expandableDatas {
            for i in 0..<expandableData.expandedIndexPaths.count {
                if expandableData.expandedIndexPaths[i] == indexPath {
                    return (true, expandableData.expandedCells[i])
                }
            }
        }
        
        return (false, UITableViewCell())
    }
    
    func isExpandable(at indexPath: IndexPath) -> Bool {
        for expandableData in expandableDatas {
            if expandableData.indexPath == indexPath {
                return false
            }
        }
        
        return true
    }
    
    func indexPathsWhere(indexPath: IndexPath) -> [IndexPath] {
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.indexPath == indexPath)
        })
        
        if filteredExpandedDatas.count > 1 {
            fatalError("Something Wrong")
        }
        
        return filteredExpandedDatas[0].expandedIndexPaths
    }
    
    func numberOfExpandedRowsInSection(section: Int) -> Int {
        var count = 0
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.indexPath.section == section)
        })
        
        for filteredExpandedData in filteredExpandedDatas {
            count += filteredExpandedData.expandedCellCount
        }
        
        return count
    }
    
    func original(indexPath: IndexPath) -> IndexPath {
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.indexPath.section == indexPath.section) && (expandedData.indexPath.row + expandedData.expandedCellCount < indexPath.row)
        })
        var count = 0
        for filteredExpandedData in filteredExpandedDatas {
            count += filteredExpandedData.expandedCellCount
        }
        
        return IndexPath(row: indexPath.row - count, section: indexPath.section)
    }
    
    func expandedCell(at indexPath: IndexPath) -> UITableViewCell? {
        for expandableData in expandableDatas {
            if let index = expandableData.expandedIndexPaths.index(of: indexPath) {
                return expandableData.expandedCells[index]
            }
        }
        
        return nil
    }
    
    func expandedHeight(at indexPath: IndexPath) -> CGFloat? {
        for expandableData in expandableDatas {
            if let index = expandableData.expandedIndexPaths.index(of: indexPath) {
                return expandableData.expandedHeights[index]
            }
        }
        
        return nil
    }
    
    func correct(indexPath: IndexPath) -> IndexPath {
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.indexPath.section == indexPath.section) && (expandedData.indexPath.row < indexPath.row)
        })

        var count = 0
        for expandableData in filteredExpandedDatas {
            count += expandableData.expandedCellCount
        }
        
        return IndexPath(row: indexPath.row - count, section: indexPath.section)
    }
}
