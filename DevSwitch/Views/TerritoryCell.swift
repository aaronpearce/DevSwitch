//
//  TerritoryCell.swift
//  Storeswitch
//
//  Created by Aaron Pearce on 23/02/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import Reusable

class TerritoryCell: UICollectionViewCell, Reusable {
    
    var shouldShowSelection: Bool = false
    let padding: CGFloat = 17
    
    let imageView: UIImageView = {
        let imageView = UIImageView().usingAutoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.lightGray
        return imageView
    }()
    
    let favoriteIconView: UIImageView = {
        let imageView = UIImageView().usingAutoLayout()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "like")
        imageView.tintColor = UIColor("#ff3b30")
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel().usingAutoLayout()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        
        contentView.addSubviews([imageView, titleLabel, favoriteIconView])
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.05
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        imageView.layer.borderColor = UIColor("#F0EFF5").cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: padding),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            favoriteIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            favoriteIconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            favoriteIconView.heightAnchor.constraint(equalToConstant: 10),
            favoriteIconView.widthAnchor.constraint(equalToConstant: 10),
        ])
        
        bringSubviewToFront(favoriteIconView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func configure(with territory: Territory, showFavorites: Bool = true) {
        titleLabel.text = territory.title
        
        imageView.image = UIImage(named: territory.code.uppercased())
        
        accessibilityLabel = territory.title
        accessibilityHint = "Double tap to switch to".localized
        
        isAccessibilityElement = true
        
        if showFavorites {
            favoriteIconView.isHidden = !territory.isFavorited
        } else {
            favoriteIconView.isHidden = true
        }
    }
}
