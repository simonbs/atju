//
//  ErrorView.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

class ErrorView: View {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitle(localize("RETRY"), for: [])
        button.setTitleColor(.white, for: [])
        return button
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        addSubview(titleLabel)
        addSubview(retryButton)
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        addConstraint(titleLabel.topAnchor.constraint(equalTo: topAnchor))
        addConstraint(titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
        addConstraint(titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor))
        addConstraint(titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor))
        
        addConstraint(retryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20))
        addConstraint(retryButton.bottomAnchor.constraint(equalTo: bottomAnchor))
        addConstraint(retryButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
        addConstraint(retryButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor))
        addConstraint(retryButton.centerXAnchor.constraint(equalTo: centerXAnchor))
    }
}
