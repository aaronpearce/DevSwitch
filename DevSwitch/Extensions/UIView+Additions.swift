//
//  UIView+Additions.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 20/02/17.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit

extension UIView {

    public func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
    }
    
    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    public func usingAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    public func constraintsToFit(view: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {

        return [
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
        ]
    }

    /**
     Removes all constrains for this view
     */
    public func removeAllConstraints() {
        var list = [NSLayoutConstraint]()
        if let constraints = superview?.constraints {
            for c in constraints {
                if c.firstItem as? UIView == self || c.secondItem as? UIView == self {
                    list.append(c)
                }
            }
        }

        superview?.removeConstraints(list)
        removeConstraints(constraints)
    }
    
    public var recursiveSubviews: [UIView] {
        var subviews = self.subviews.compactMap({$0})
        subviews.forEach { subviews.append(contentsOf: $0.recursiveSubviews) }
        return subviews
    }
}

extension UIEdgeInsets {
    static func inset(by inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
