//
//  ExpandableData.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 8..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

struct ExpandedData {
    var indexPath: IndexPath
    var expanedCells: [UITableViewCell]
}

class ExpandableData {
    var expandedDatas = [ExpandedData]()
    
    func append(indexPath: IndexPath, expandedCells: [UITableViewCell]) {
        expandedDatas.append(ExpandedData(indexPath: indexPath, expanedCells: expandedCells))
    }
    
    func indexPathsWhere(indexPath: IndexPath) -> [IndexPath] {
        guard let foo = expandedDatas.enumerated().first(where: {$0.element.indexPath == indexPath}) else { return [IndexPath]() }
        let count = foo.element.expanedCells.count
        
        var indexPaths = [IndexPath]()
        
        for i in 1..<count {
            let tempIndexPath = IndexPath(row: indexPath.row + i, section: indexPath.section)
            indexPaths.append(tempIndexPath)
        }
        return indexPaths
    }
    
    func numberOfExpandedRowsInSection(section: Int) -> Int {
        var count = 0
        let filteredExpandedDatas = expandedDatas.filter( { (expandedData: ExpandedData) -> Bool in return (expandedData.indexPath.section == section) } )
        
        for filteredExpandedData in filteredExpandedDatas {
            count += filteredExpandedData.expanedCells.count
        }
        
        return count
    }
    
}

