//
//  TerritoryHeaderView.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 27/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import Reusable

class TerritoryHeaderView: UICollectionReusableView, Reusable {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel().usingAutoLayout()
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = UIColor("#999999")
        return titleLabel
    }()
    
    let contentView = UIView().usingAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        addSubview(contentView)
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate(contentView.constraintsToFit(view: self, insets: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)))
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
