//
//  ExpandableCellDelegate.swift
//  ExpandableCell
//
//  Created by Jonathan Gomes on 24/07/19.
//  Copyright © 2019 SeungyounYi. All rights reserved.
//

import Foundation

import UIKit

public protocol ExpandableCellDelegate {
    
    func expandableCell(expandedCell expandableCell: ExpandableCell)
    func expandableCell(collapsedCell expandableCell: ExpandableCell)
    
}
