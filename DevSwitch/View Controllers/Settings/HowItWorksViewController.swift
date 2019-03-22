//
//  HowItWorksViewController.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 1/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit
import WebKit

class HowItWorksViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView().usingAutoLayout()
        scrollView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        return scrollView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView().usingAutoLayout()
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Guide".localized
        view.backgroundColor = UIColor("#F0EFF5")
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate(scrollView.constraintsToFit(view: view, insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)))
        
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        var favoriteActionText = "long press".localized
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            favoriteActionText = "3D Touch".localized
        }
        
        addTextView(for: """
        DevSwitch generates crafted App Store links to allow your device to switch to a specific storefront to allow you to view information such as features, rankings and the Today tab per storefront.

        It does not allow you to purchase from the storefront unless your currently logged in account is set to that region for purchasing.

        To favourite a storefront, \(favoriteActionText) the storefront.

        Switching to a storefront will show the below confirmation dialog:
        """.localized)
        
        addImageView(for: UIImage(named: "switch-store-guide")!)
        
        addTextView(for: "Switching to a storefront that you are already on will show the following dialog:".localized)
        
        addImageView(for: UIImage(named: "on-store-guide")!)
    }
    
    func addTextView(for text: String) {
        let textView = UITextView().usingAutoLayout()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.text = text

        contentStackView.addArrangedSubview(textView)
    }
    
    func addImageView(for image: UIImage) {
        let imageView = UIImageView().usingAutoLayout()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.image = image
        
        contentStackView.addArrangedSubview(imageView)
        
        imageView.heightAnchor.constraint(equalTo: contentStackView.widthAnchor).isActive = true
    }
}


