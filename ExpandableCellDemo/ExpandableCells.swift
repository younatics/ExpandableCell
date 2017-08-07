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
    override func awakeFromNib() {
        self.style = .normal
    }
}

class ExpandableExpandableCell: ExpandableCell {
    override func awakeFromNib() {
        self.style = .expandable
    }
}

class ExpandableExpandedCell: ExpandableCell {
    override func awakeFromNib() {
        self.style = .expanded
    }
}
