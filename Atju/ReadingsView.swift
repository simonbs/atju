//
//  ReadingsView.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

extension Pollen.Sort {
    var order: Int {
        switch self {
        case græs: return 0
        case bynke: return 1
        case birk: return 2
        case el: return 3
        case hassel: return 4
        case elm: return 5
        case cladosporium: return 6
        case alternaria: return 7
        }
    }
    
    var color: UIColor {
        switch self {
        case græs: return UIColor(hex: 0x295c27)
        case bynke: return UIColor(hex: 0x227f1b)
        case birk: return UIColor(hex: 0x3da416)
        case el: return UIColor(hex: 0x90c716)
        case hassel: return UIColor(hex: 0xc4c11b)
        case elm: return UIColor(hex: 0xd89323)
        case cladosporium: return UIColor(hex: 0xd1731d)
        case alternaria: return UIColor(hex: 0xb4610d)
        }
    }
}

extension Pollen.Reading {
    var displayableValue: String {
        guard value == "-" else { return value }
        switch sort {
        case .græs: return "0"
        case .bynke: return "0"
        case .birk: return "0"
        case .el: return "0"
        case .hassel: return "0"
        case .elm: return "0"
        case .cladosporium: return "-"
        case .alternaria: return "-"
        }
    }
}

class ReadingsView: View {
    var topLayoutGuide: UILayoutSupport? {
        didSet { setNeedsUpdateConstraints() }
    }
    
    private var collectionViewTopConstraint: NSLayoutConstraint?
    
    let collectionView: CollectionView<UICollectionViewFlowLayout> = {
        let collectionView = CollectionView<UICollectionViewFlowLayout>()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor(hex: 0x232323)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.layout.scrollDirection = .vertical
        collectionView.layout.minimumLineSpacing = 0
        collectionView.layout.minimumInteritemSpacing = 0
        collectionView.alpha = 0
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white()
        refreshControl.isEnabled = false
        return refreshControl
    }()
    
    let loadingIndicatorView: UIActivityIndicatorView = {
        let loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.alpha = 1
        return loadingIndicatorView
    }()
    
    let errorView: ErrorView = {
        let errorView = ErrorView()
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.titleLabel.text = localize("FAILED_LOADING_READINGS")
        errorView.alpha = 0
        return errorView
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        backgroundColor = UIColor(hex: 0x232323)
        addSubview(loadingIndicatorView)
        addSubview(errorView)
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let length = bounds.width / 2
        collectionView.layout.itemSize = CGSize(width: length, height: length)
        if #available(iOS 10, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.insertSubview(refreshControl, at: 0)
        }
    }
    
    override func defineLayout() {
        super.defineLayout()
        
        addConstraint(loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor))
        addConstraint(loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor))
        
        addConstraint(collectionView.leadingAnchor.constraint(equalTo: leadingAnchor))
        addConstraint(collectionView.trailingAnchor.constraint(equalTo: trailingAnchor))
        collectionViewTopConstraint = shp_addConstraint(collectionView.topAnchor.constraint(equalTo: topAnchor))
        addConstraint(collectionView.bottomAnchor.constraint(equalTo: bottomAnchor))
        
        addConstraint(errorView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
        addConstraint(errorView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor))
        addConstraint(errorView.centerXAnchor.constraint(equalTo: centerXAnchor))
        addConstraint(errorView.centerYAnchor.constraint(equalTo: centerYAnchor))
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if let topLayoutGuide = topLayoutGuide {
            collectionViewTopConstraint => removeConstraint
            collectionViewTopConstraint = shp_addConstraint(collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor))
        }
    }
    
    func showLoading() {
        loadingIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.3) {
            self.loadingIndicatorView.alpha = 1
            self.errorView.alpha = 0
            self.collectionView.alpha = 0
        }
    }
    
    func showError() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingIndicatorView.alpha = 0
            self.errorView.alpha = 1
            self.collectionView.alpha = 0
        }) { _ in
            self.loadingIndicatorView.stopAnimating()
        }
    }
    
    func showContent() {
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingIndicatorView.alpha = 0
            self.errorView.alpha = 0
            self.collectionView.alpha = 1
        }) { _ in
            self.loadingIndicatorView.stopAnimating()
        }
    }
} 
