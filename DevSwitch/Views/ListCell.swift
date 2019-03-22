//
//  ListCell.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 2/10/18.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import HomeKit
import Reusable
import SwipeCellKit

class ListCell: SwipeCollectionViewCell, Reusable {
    let padding: CGFloat = 12
    
    let internalContentView = UIView().usingAutoLayout()
    
    let titleLabel: UILabel = {
        let label = UILabel().usingAutoLayout()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel().usingAutoLayout()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView().usingAutoLayout()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        return stackView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView().usingAutoLayout()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(labelStackView)
        
        return stackView
    }()
    
    var leftAccessoryView: UIView? {
        willSet(newValue){
            leftAccessoryView?.removeFromSuperview()
            if let newValue = newValue {
                contentStackView.insertArrangedSubview(newValue, at: 0)
                contentStackView.setCustomSpacing(16, after: newValue)
            }
        }
    }
    
    var rightAccessoryView: UIView? {
        willSet(newValue){
            rightAccessoryView?.removeFromSuperview()
            if let newValue = newValue {
                contentStackView.addArrangedSubview(newValue)
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                internalContentView.layer.borderWidth = 2
                internalContentView.layer.borderColor = UIColor.lightGray.cgColor
            } else {
                internalContentView.layer.borderWidth = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        internalContentView.layer.cornerRadius = 8
        internalContentView.layer.masksToBounds = true
        internalContentView.backgroundColor = .white
        
        contentView.addSubview(internalContentView)
        internalContentView.addSubview(contentStackView)
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        contentView.layer.shadowRadius = 2.0
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.masksToBounds = false
        contentView.layer.shadowPath = UIBezierPath(roundedRect: internalContentView.bounds, cornerRadius: internalContentView.layer.cornerRadius).cgPath
        
        NSLayoutConstraint.activate(internalContentView.constraintsToFit(view: contentView))
        NSLayoutConstraint.activate(contentStackView.constraintsToFit(view: internalContentView, insets: UIEdgeInsets(top: padding, left: 24, bottom: padding, right: 24)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowPath = UIBezierPath(roundedRect: internalContentView.bounds, cornerRadius: internalContentView.layer.cornerRadius).cgPath
    }
    
    func configure(title: String, subtitle: String? = nil, leftAccessoryView: UIView? = nil, rightAccessoryView: UIView? = nil) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        self.leftAccessoryView = leftAccessoryView
        self.rightAccessoryView = rightAccessoryView
        
        var accessibilityString = title
        if let subtitle = subtitle {
            accessibilityString = "\(title), \(subtitle)"
        }
        
        accessibilityLabel = accessibilityString
        isAccessibilityElement = true
    }
}

