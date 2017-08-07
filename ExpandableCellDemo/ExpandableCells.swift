//
//  ExpandableCells.swift
//  ExpandableCell
//
//  Created by Seungyoun Yi on 2017. 8. 7..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit
import ExpandableCell

class ExpandableNormalCell: ExpandableCell {
    static let ID = "ExpandableNormalCell"
    override func awakeFromNib() {
        self.style = .normal
    }
}

class ExpandableExpandableCell: ExpandableCell {
    static let ID = "ExpandableExpandableCell"

    override func awakeFromNib() {
        self.style = .expandable
    }
}

class ExpandableExpandedCell: ExpandableCell {
    static let ID = "ExpandableExpandedCell"

    override func awakeFromNib() {
        self.style = .expanded
    }
}
