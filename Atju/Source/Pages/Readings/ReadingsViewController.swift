//
//  ReadingsViewController.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import UIKit

class ReadingsViewController: ViewController<ReadingsView>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private static let cellIdentifier = "ReadingCell"
    private static let footerIdentifier = "PrognoseFooter"
    private let viewModel = ReadingsView.ViewModel()
    private var isApplicationInBackground = false
    private var isLoadingPollen = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override init() {
        super.init()
        let segmentedControl = UISegmentedControl(items: [
            Pollen.City.copenhagen.title,
            Pollen.City.viborg.title
        ])
        segmentedControl.selectedSegmentIndex = viewModel.selectedCity.segmentIndex
        segmentedControl.addTarget(self, action: #selector(didSelectSegment), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pollenUpdatedFromRemoteNotification), 
            name: Notification.PollenUpdatedFromRemoteNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self, 
            selector: #selector(applicationDidBecomeActive), 
            name: .UIApplicationDidBecomeActive,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground),
            name: .UIApplicationDidEnterBackground,
            object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.topLayoutGuide = topLayoutGuide
        contentView.errorView.retryButton.addTarget(self, action: #selector(retryLoading), for: .touchUpInside)
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
        contentView.collectionView.register(ReadingCollectionViewCell.self, forCellWithReuseIdentifier: ReadingsViewController.cellIdentifier)
        contentView.collectionView.register(PrognoseReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ReadingsViewController.footerIdentifier)
        contentView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        performInitialLoad()
    }
    
    dynamic private func applicationDidEnterBackground() {
        isApplicationInBackground = true
    }
    
    dynamic private func applicationDidBecomeActive() {
        // We want to make sure the application have been in the background
        // as the UIApplicationDidEnterBackground notification is also sent
        // on first launch.
        guard isApplicationInBackground else { return }
        isApplicationInBackground = false
        refreshFromCache()
    }
    
    dynamic private func pollenUpdatedFromRemoteNotification() {
        refreshFromCache()
    }
    
    dynamic private func didSelectSegment(segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0: viewModel.selectedCity = .copenhagen
        case 1: viewModel.selectedCity = .viborg
        default: break
        }
        contentView.collectionView.reloadData()
    }
    
    dynamic private func refresh() {
        contentView.refreshControl.beginRefreshing()
        reload()
    }
    
    dynamic private func retryLoading() {
        contentView.showLoading()
        reload()
    }
    
    private func refreshFromCache() {
        guard !isLoadingPollen else { return }
        isLoadingPollen = true
        viewModel.loadCachedPollen { [weak self] result in
            self?.isLoadingPollen = false
            switch result {
            case .value:
                self?.contentView.collectionView.reloadData()
            case .error:
                break
            }
        }
    }
    
    private func performInitialLoad() {
        if viewModel.hasCachedPollen {
            // We should have some cached data, so let's load it.
            isLoadingPollen = true
            viewModel.loadCachedPollen { [weak self] result in
                guard let strongSelf = self else { return }
                strongSelf.isLoadingPollen = false
                switch result {
                case .value:
                    // Show the cached data and then perform a reload to get the newest data.
                    strongSelf.contentView.collectionView.reloadData()
                    strongSelf.contentView.showContent()
                    let scrolledContentOffset = CGPoint(
                        x: strongSelf.contentView.collectionView.contentOffset.x,
                        y: -strongSelf.contentView.refreshControl.frame.height)
                    // We need to call beginRefreshing after setting content offset to avoid
                    // an iOS bug where the tint color of the UIRefreshControl would otherwise
                    // not be correct.
                    strongSelf.contentView.collectionView.contentOffset = scrolledContentOffset
                    strongSelf.contentView.refreshControl.beginRefreshing()
                    strongSelf.contentView.refreshControl.isEnabled = false
                    strongSelf.reload()
                case .error:
                    // Loading cached data failed. Perform a reload.
                    strongSelf.contentView.showLoading()
                    strongSelf.reload()
                }
            }
        } else {
            // We have no cached data.
            contentView.showLoading()
            reload()
        }
    }
    
    private func reload() {
        isLoadingPollen = true
        viewModel.refresh { [weak self] result in
            self?.isLoadingPollen = false
            switch result {
            case .value:
                self?.contentView.refreshControl.endRefreshing()
                self?.contentView.refreshControl.isEnabled = true
                self?.contentView.collectionView.reloadData()
                self?.contentView.showContent()
            case .error:
                self?.contentView.refreshControl.endRefreshing()
                self?.contentView.refreshControl.isEnabled = false
                self?.contentView.showError()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModelsForSelectedCity.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.cellViewModels[viewModel.selectedCity]?[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReadingsViewController.cellIdentifier, for: indexPath) as? ReadingCollectionViewCell else {
            fatalError("Unable to get ReadingCollectionViewCell")
        }
        cell.latestTitleLabel.text = cellViewModel?.title
        cell.latestValueLabel.text = cellViewModel?.value
        cell.latestDateLabel.text = cellViewModel?.date
        cell.previousLabel.text = cellViewModel?.previousTitle
        cell.contentView.backgroundColor = cellViewModel?.color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let _ = viewModel.prognoseViewModel?.text else { return .zero }
        contentView.sizingFooterView.textLabel.text = viewModel.prognoseViewModel?.text
        return contentView.sizingFooterView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionElementKindSectionFooter else {
            fatalError("Was asked to return a supplementary view for unsupported element kind: \(kind)")
        }
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, 
            withReuseIdentifier: ReadingsViewController.footerIdentifier, 
            for: indexPath)
        guard let prognoseView = view as? PrognoseReusableView else {
            fatalError("Footer view cannot be casted to a prognose view.")
        }        
        prognoseView.textLabel.text = viewModel.prognoseViewModel?.text
        return prognoseView
    }
}

private extension Pollen.City {
    var segmentIndex: Int {
        switch self {
        case .copenhagen: return 0
        case .viborg: return 1
        }
    }
}
