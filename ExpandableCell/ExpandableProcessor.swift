//
//  ExpandableData.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 8..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

struct ExpandableData {
    // 그냥 인덱스 패쓰를 받은 후 클릭 한 후  오리지널 인덱스 패쓰를 저장 -> 그 이후 expandedIndexPaths를 인덱스 패쓰기준으로 세팅 -> 만약 인덱스 패쓰와 오리지널 인덱스 패쓰가 다른 경우에는 expandedIndexPaths를 다시 수정하여 저장 하면 버그가 없지 않을 까?
    // ㅋ
    var clickedIndexPath: IndexPath
    var originalIndexPath: IndexPath
    var expandedCells: [UITableViewCell]
    var expandedIndexPaths: [IndexPath] {
        var indexPaths = [IndexPath]()
        for i in 0..<expandedCells.count {
            let indexPath = IndexPath(row: clickedIndexPath.row + i + 1 , section: clickedIndexPath.section)
            indexPaths.append(indexPath)
        }
        // 실시간으로 인덱스가 반영되어야함 클릭트 인덱스 패쓰가 있어도 다음 것이 오면 다시 반영되야함.
        print("clickedIndexPath: \(clickedIndexPath), originalIndexPath: \(originalIndexPath), expandedIndexPaths: \(indexPaths)")
        return indexPaths
    }
    var expandedCellCount: Int {
        return expandedCells.count
    }
}

class ExpandableProcessor {
    var expandableDatas = [ExpandableData]()
    var willRemovedIndexPaths: [IndexPath]?
    
    func insert(indexPath: IndexPath, expandedCells: [UITableViewCell]) {
        expandableDatas.append(ExpandableData(clickedIndexPath: indexPath, originalIndexPath: original(indexPath: indexPath), expandedCells: expandedCells))
    }
    
    func delete(indexPath: IndexPath) {
        for i in 0..<expandableDatas.count {
            if expandableDatas[i].clickedIndexPath == indexPath {
                willRemovedIndexPaths = expandableDatas[i].expandedIndexPaths
                print(expandableDatas[i].clickedIndexPath)
                print(expandableDatas[i].originalIndexPath)
                expandableDatas.remove(at: i)
                
                return
            }
        }
    }
    
    func isAlreadyExpanded(indexPath: IndexPath) -> Bool {
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath == indexPath)
        })
        
        if filteredExpandedDatas.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func indexPathsWhere(indexPath: IndexPath) -> [IndexPath] {
        let filteredExpandedDatas = expandableDatas.filter({ (expandedData: ExpandableData) -> Bool in
            return (expandedData.clickedIndexPath == indexPath)
        })
        
        if filteredExpandedDatas.count > 1 {
            fatalError("Something Wrong")
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
            if let index = expandableData.expandedIndexPaths.index(of: indexPath) {
                return expandableData.expandedCells[index]
            }
        }
        
        print("expandedCell indexPath: \(indexPath)")
        print("expandedCell originalIndexPath: \(originalIndexPath)")

        return nil
    }
    
}

