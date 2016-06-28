//
//  ReadingsViewController.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import UIKit

class ReadingsViewController: ViewController<ReadingsView>, UICollectionViewDataSource {
    private static let cellIdentifier = "ReadingCell"    
    private let viewModel = ReadingsView.ViewModel()
    
    override init() {
        super.init()
        let segmentedControl = UISegmentedControl(items: [
            ReadingsView.ViewModel.CitySegment.copenhagen.title,
            ReadingsView.ViewModel.CitySegment.viborg.title
        ])
        segmentedControl.selectedSegmentIndex = viewModel.selectedCitySegment.rawValue
        segmentedControl.addTarget(self, action: #selector(didSelectSegment), for: .valueChanged)
        navigationItem.titleView = segmentedControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.topLayoutGuide = topLayoutGuide
        contentView.errorView.retryButton.addTarget(self, action: #selector(performInitialLoad), for: .touchUpInside)
        contentView.collectionView.dataSource = self
        contentView.collectionView.register(ReadingCollectionViewCell.self, forCellWithReuseIdentifier: ReadingsViewController.cellIdentifier)
        contentView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        reload()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .lightContent
    }
    
    dynamic private func refresh() {
        contentView.refreshControl.beginRefreshing()
        reload()
    }
    
    dynamic private func performInitialLoad() {
        contentView.showLoading()
        reload()
    }
    
    private func reload() {
        viewModel.getPollen(update: { [weak self] in
            self?.contentView.refreshControl.endRefreshing()
            self?.contentView.refreshControl.isEnabled = true
            self?.contentView.collectionView.reloadData()
            self?.contentView.showContent()
        }) { [weak self] _ in
            self?.contentView.refreshControl.endRefreshing()
            self?.contentView.refreshControl.isEnabled = false
            self?.contentView.showError()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellViewModel = viewModel.cellViewModels[viewModel.selectedCitySegment.city]?[indexPath.row]
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
    
    dynamic private func didSelectSegment(segmentedControl: UISegmentedControl) {
        guard let selectedSegment = ReadingsView.ViewModel.CitySegment(rawValue: segmentedControl.selectedSegmentIndex) else { return }
        viewModel.selectedCitySegment = selectedSegment
        contentView.collectionView.reloadData()
    }
}
