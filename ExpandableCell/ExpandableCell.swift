//
//  ExpandableCell.swift
//  ExpandableCell
//
//  Created by Seungyoun Yi on 2017. 8. 10..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableCell: UITableViewCell {
    open var arrowImageView: UIImageView!
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()

    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    func initView() {
        let width = UIScreen.main.bounds.width
        let height = self.frame.height
        
        arrowImageView = UIImageView(frame: CGRect(x: width - 30, y: (height - 13)/2, width: 13, height: 13))
        arrowImageView.image = UIImage(named: "expandableCell_arrow", in: Bundle(for: ExpandableCell.self), compatibleWith: nil)
        self.contentView.addSubview(arrowImageView)
        
    }
}
