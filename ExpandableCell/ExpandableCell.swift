//
//  ExpandableCell.swift
//  ExpandableCell
//
//  Created by Seungyoun Yi on 2017. 8. 10..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableCell: UITableViewCell {
    open var arrowImageView = UIImageView()
    open var trailingMargin: CGFloat = 16
    open var highlightAnimation = HighlightAnimation.animated
    private var isOpen = false
    private var initialExpansionAllowed = true
    private var arrowConstraintsInstalled = false
    private var arrowTrailingConstraint: NSLayoutConstraint?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()

        MainActor.assumeIsolated {
            initView()
        }
    }
    
    func initView() {
        arrowImageView.image = UIImage(named: "expandableCell_arrow", in: .expandableCell, compatibleWith: nil)
        self.contentView.addSubview(arrowImageView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        // Install the arrow's constraints once. Re-adding them on every layout
        // pass (as earlier versions did) accumulated duplicate constraints.
        if !arrowConstraintsInstalled {
            arrowImageView.translatesAutoresizingMaskIntoConstraints = false
            let trailingConstraint = arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -trailingMargin)
            arrowTrailingConstraint = trailingConstraint
            NSLayoutConstraint.activate([
                arrowImageView.widthAnchor.constraint(equalToConstant: 22),
                arrowImageView.heightAnchor.constraint(equalToConstant: 11),
                arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                trailingConstraint,
            ])
            arrowConstraintsInstalled = true
        } else {
            // Keep honoring a changed `trailingMargin` without re-adding constraints.
            arrowTrailingConstraint?.constant = -trailingMargin
        }
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

private final class BundleToken {}

extension Bundle {
    /// The bundle that ships ExpandableCell's asset catalog, resolved for every
    /// integration path: Swift Package Manager (`Bundle.module`), CocoaPods
    /// (`resource_bundles` → `ExpandableCell.bundle`), and a plain framework.
    static var expandableCell: Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        let host = Bundle(for: BundleToken.self)
        if let url = host.url(forResource: "ExpandableCell", withExtension: "bundle"),
           let resourceBundle = Bundle(url: url) {
            return resourceBundle
        }
        return host
        #endif
    }
}
