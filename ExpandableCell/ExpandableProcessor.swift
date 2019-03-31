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
    var isSelectable: Bool
    
    var expandedIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        for i in 0..<expandedCells.count {
            let indexPath = IndexPath(row: self.indexPath.row + i + 1, section: self.indexPath.section)
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
    var expandableDatasPerSection = [Int: [ExpandableData]]()
    var willRemovedIndexPaths: [IndexPath]?
    
    func insert(indexPath: IndexPath, expandedCells: [UITableViewCell], expandedHeights: [CGFloat], isExpandCellSelectable: Bool) -> Bool {
        var expandableDatas: [ExpandableData] = [ExpandableData]()
        
        if expandableDatasPerSection.keys.contains(indexPath.section), var array = expandableDatasPerSection[indexPath.section] {
            for i in 0..<array.count {
                let expandableData = array[i]
                //            guard expandableData.indexPath.section == indexPath.section else { return false }
                
                if expandableData.indexPath.row > indexPath.row {
                    array[i].indexPath = IndexPath(row: expandableData.indexPath.row + expandedCells.count, section: expandableData.indexPath.section)
                }
            }
            expandableDatas = array
        }
        expandableDatas.append(ExpandableData(indexPath: indexPath, originalIndexPath: original(indexPath: indexPath), expandedCells: expandedCells, expandedHeights: expandedHeights, isSelectable: isExpandCellSelectable))
        expandableDatasPerSection[indexPath.section] = expandableDatas
        
        return true
    }
    
    func delete(indexPath: IndexPath) {
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            var expandableDatas = expandableDatasPerSection[indexPath.section] else { return }
        
        var deletedIndexPath = IndexPath(row: 0, section: 0)
        var deletedCellCount = 0
        
        for i in 0..<expandableDatas.count where expandableDatas[i].indexPath == indexPath {
            let expandableData = expandableDatas[i]
            willRemovedIndexPaths = expandableData.expandedIndexPaths
            deletedIndexPath = expandableData.indexPath
            deletedCellCount = expandableData.expandedCellCount
            expandableDatas.remove(at: i)
            break
        }
        
        for i in 0..<expandableDatas.count {
            let expandableData = expandableDatas[i]
            guard expandableData.indexPath.section == deletedIndexPath.section else { return }
            
            if expandableData.indexPath.row > deletedIndexPath.row {
                expandableDatas[i].indexPath = IndexPath(row: expandableData.indexPath.row - deletedCellCount, section: expandableData.indexPath.section)
            }
        }
        
        expandableDatasPerSection[indexPath.section] = expandableDatas
    }
    
    func deleteAllIndexPathsInSection(_ section: Int) -> (expandedIndexPaths: [IndexPath], indexPaths: [IndexPath]) {
        var expandedIndexPaths = [IndexPath]()
        var indexPaths = [IndexPath]()
        
        if let expandableDataInSection = expandableDatasPerSection[section] {
            for expandableData in expandableDataInSection {
                indexPaths.append(expandableData.indexPath)
                for expandedIndexPath in expandableData.expandedIndexPaths {
                    expandedIndexPaths.append(expandedIndexPath)
                }
            }
        }
        
        expandableDatasPerSection.removeValue(forKey: section)
        
        return (expandedIndexPaths, indexPaths)
    }
    
    func deleteAllIndexPaths() -> (expandedIndexPaths:[IndexPath], indexPaths: [IndexPath]) {
        var expandedIndexPaths = [IndexPath]()
        var indexPaths = [IndexPath]()
        
        for expandableDataPerSection in Array(expandableDatasPerSection.values) {
            for expandableData in expandableDataPerSection {
                indexPaths.append(expandableData.indexPath)
                for expandedIndexPath in expandableData.expandedIndexPaths {
                    expandedIndexPaths.append(expandedIndexPath)
                }
            }
        }
        
        expandableDatasPerSection.removeAll()
        
        return (expandedIndexPaths, indexPaths)
    }
    
    func isExpandedCell(at indexPath: IndexPath) -> (isExpandedCell: Bool, expandedCell: UITableViewCell) {
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            let expandableDatas = expandableDatasPerSection[indexPath.section] else { return (false, UITableViewCell()) }
        
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
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            let expandableDatas = expandableDatasPerSection[indexPath.section] else { return true }
        
        for expandableData in expandableDatas {
            if expandableData.indexPath == indexPath {
                return false
            }
        }
        
        return true
    }
    
    func isSelectable(at indexPath: IndexPath, defaultValue: Bool) -> Bool {
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            let expandableDatas = expandableDatasPerSection[indexPath.section] else { return true }
        
        for expandableData in expandableDatas {
            if expandableData.indexPath == indexPath {
                return expandableData.isSelectable
            }
        }
        
        return defaultValue
    }
    
    func indexPathsWhere(indexPath: IndexPath) -> [IndexPath] {
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            let expandableDatas = expandableDatasPerSection[indexPath.section] else { return [] }
        
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.indexPath == indexPath)
        })
        
        if filteredExpandedDatas.count > 1 {
            fatalError("Something Wrong")
        }
        
        return filteredExpandedDatas[0].expandedIndexPaths
    }
    
    func numberOfExpandedRowsInSection(section: Int) -> Int {
        guard expandableDatasPerSection.keys.contains(section),
            let expandableDatas = expandableDatasPerSection[section] else { return 0 }
        
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
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            let expandableDatas = expandableDatasPerSection[indexPath.section] else { return IndexPath(row: indexPath.row, section: indexPath.section) }
        
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
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            let expandableDatas = expandableDatasPerSection[indexPath.section] else { return nil }
        
        for expandableData in expandableDatas {
            if let index = expandableData.expandedIndexPaths.firstIndex(of: indexPath),
                index < expandableData.expandedCells.count {
                return expandableData.expandedCells[index]
            }
        }
        
        return nil
    }
    
    func expandedHeight(at indexPath: IndexPath) -> CGFloat? {
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            let expandableDatas = expandableDatasPerSection[indexPath.section] else { return nil }
        
        for expandableData in expandableDatas {
            if let index = expandableData.expandedIndexPaths.firstIndex(of: indexPath),
                index < expandableData.expandedHeights.count {
                return expandableData.expandedHeights[index]
            }
        }
        
        return nil
    }
    
    func correct(indexPath: IndexPath) -> IndexPath {
        guard expandableDatasPerSection.keys.contains(indexPath.section),
            let expandableDatas = expandableDatasPerSection[indexPath.section] else { return IndexPath(row: 0, section: 0) }
        
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
