//
//  ReadingCollectionViewCell.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

extension ReadingCollectionViewCell {
    class ViewModel {
        struct Reading {
            let value: String
            let date: Date
        }
        
        let city: Pollen.City
        let sort: Pollen.Sort
        let latestReading: Reading?
        let previousReading: Reading?
        
        let color: UIColor
        let title: String
        let value: String
        let date: String?
        let previousTitle: String?
        let order: Int
        
        init(sort: Pollen.Sort, city: Pollen.City, latestReading: Reading?, previousReading: Reading?) {
            self.sort = sort
            self.city = city
            self.latestReading = latestReading
            self.previousReading = previousReading
            
            self.color = sort.color
            self.title = sort.rawValue
            self.value = latestReading?.value ?? "-"
            self.date = latestReading?.date => RelativeDateFormatter.string
            self.order = sort.order
            
            if let previousReading = previousReading {
                self.previousTitle = RelativeDateFormatter.string(from: previousReading.date) + ": " + previousReading.value
            } else {
                self.previousTitle = nil
            }
        }
    }
}

class ReadingCollectionViewCell: CollectionViewCell {
    let latestTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold)
        label.textColor = UIColor.white().withAlphaComponent(0.93)
        return label
    }()
    
    let latestValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 42, weight: UIFontWeightBlack)
        label.textColor = UIColor.white().withAlphaComponent(0.93)
        return label
    }()
    
    let latestDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightRegular)
        label.textColor = UIColor.white().withAlphaComponent(0.93)
        return label
    }()
    
    let previousLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
        label.textColor = UIColor.white().withAlphaComponent(0.85)
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        containerView.addSubview(latestTitleLabel)
        containerView.addSubview(latestValueLabel)
        containerView.addSubview(latestDateLabel)
        containerView.addSubview(previousLabel)
        contentView.addSubview(containerView)
        contentView.backgroundColor = .red()
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        containerView.addConstraint(latestTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor))
        containerView.addConstraint(latestTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor))
        containerView.addConstraint(latestTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor))
        containerView.addConstraint(latestTitleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor))
        
        containerView.addConstraint(latestDateLabel.topAnchor.constraint(equalTo: latestTitleLabel.bottomAnchor))
        containerView.addConstraint(latestDateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor))
        containerView.addConstraint(latestDateLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor))
        containerView.addConstraint(latestDateLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor))
        
        containerView.addConstraint(latestValueLabel.topAnchor.constraint(equalTo: latestDateLabel.bottomAnchor, constant: 5))
        containerView.addConstraint(latestValueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor))
        containerView.addConstraint(latestValueLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor))
        containerView.addConstraint(latestValueLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor))
        
        containerView.addConstraint(previousLabel.topAnchor.constraint(equalTo: latestValueLabel.bottomAnchor, constant: 5))
        containerView.addConstraint(previousLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor))
        containerView.addConstraint(previousLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor))
        containerView.addConstraint(previousLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor))
        containerView.addConstraint(previousLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor))
        
        contentView.addConstraint(containerView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor))
        contentView.addConstraint(containerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor))
        contentView.addConstraint(containerView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor))
        contentView.addConstraint(containerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor))
        contentView.addConstraint(containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor))
        contentView.addConstraint(containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor))
    }
}
