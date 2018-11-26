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
    open var rightMargin: CGFloat = 16
    open var highlightAnimation = HighlightAnimation.animated
    private var isOpen = false
    private var initialExpansionAllowed = true

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initView()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        initView()
    }

    func initView() {
        arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "expandableCell_arrow", in: Bundle(for: ExpandableCell.self), compatibleWith: nil)
        self.contentView.addSubview(arrowImageView)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        let width = self.bounds.width
        let height = self.bounds.height

        arrowImageView.frame = CGRect(x: width - rightMargin, y: (height - 11)/2, width: 22, height: 11)
    }

    func open() {
        self.isOpen = true
        self.initialExpansionAllowed = false
        if highlightAnimation == .animated {
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 1.0, 0.0, 0.0)
            }
        }
    }

    func close() {
        self.isOpen = false
        if highlightAnimation == .animated {
            UIView.animate(withDuration: 0.3) {[weak self] in
                self?.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 0.0, 0.0, 0.0)
            }
        }
    }
    
    func isInitiallyExpandedInternal() -> Bool {
        return self.initialExpansionAllowed && self.isInitiallyExpanded()
    }

    open func isExpanded() -> Bool {
        return isOpen
    }
    
    open func isInitiallyExpanded() -> Bool {
        return false
    }
    
    open func isSelectable() -> Bool {
        return false
    }
}

public enum HighlightAnimation {
    case animated
    case none
}
