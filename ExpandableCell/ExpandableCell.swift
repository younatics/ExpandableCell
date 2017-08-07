//
//  ExpandableCell.swift
//  ExpandableCell
//
//  Created by YiSeungyoun on 2017. 8. 6..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableCell: UITableViewCell {
    public var style: ExpandableCellStyle = .normal
    public var isExpanded = false
    
    public init(style: UITableViewCellStyle, reuseIdentifier: String?, expandableStyle: ExpandableCellStyle, isExpanded: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style = expandableStyle
        self.isExpanded = isExpanded

    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    
}
