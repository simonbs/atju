//
//  PrognoseCollectionViewCell.swift
//  Atju
//
//  Created by Simon Støvring on 04/07/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

extension PrognoseReusableView {
    struct ViewModel {
        let text: String
        
        init(text: String) {
            self.text = text
        }
    }
}

class PrognoseReusableView: CollectionReusableView {
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.white.withAlphaComponent(0.88)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
        return label
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(textLabel)
    }
    
    override func defineLayout() {
        super.defineLayout()
        addConstraint(textLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: layoutMargins.left))
        addConstraint(textLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: layoutMargins.bottom))
        addConstraint(textLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: layoutMargins.left))
        addConstraint(textLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: layoutMargins.right))
        addConstraint(textLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
        addConstraint(textLabel.centerYAnchor.constraint(equalTo: centerYAnchor))
    }
}
