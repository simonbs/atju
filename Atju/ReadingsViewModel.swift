//
//  ReadingsViewModel.swift
//  Atju
//
//  Created by Simon Støvring on 19/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

extension Pollen.City {
    var title: String {
        switch self {
        case .copenhagen: return localize("COPENHAGEN")
        case .viborg: return localize("VIBORG")
        }
    }
}

extension ReadingsView {
    class ViewModel {
        private let client = AtjuClient()
        private(set) var cellViewModels: [Pollen.City: [ReadingCollectionViewCell.ViewModel]] = [:]
        var selectedCity: Pollen.City = .copenhagen
        var selectedCellViewModels: [ReadingCollectionViewCell.ViewModel] {
            return cellViewModels[selectedCity] ?? []
        }
        
        func getPollen(update: (() -> Void), failure: ((AtjuClient.Error) -> Void)) {
            client.getPollen(success: { [weak self] pollen in
                guard let strongSelf = self else { return }
                DispatchQueue.global(attributes: .qosBackground).async {
                    var cellViewModels: [Pollen.City: [ReadingCollectionViewCell.ViewModel]] = [:]
                    cellViewModels = strongSelf.insert(day: pollen.latest, in: cellViewModels, isPrevious: false)
                    if let previous = pollen.previous {
                        cellViewModels = strongSelf.insert(day: previous, in: cellViewModels, isPrevious: true)
                    }
                    
                    self?.cellViewModels = cellViewModels
                    DispatchQueue.main.async {
                        update()
                    }
                }
            }) { error in
                failure(error)
            }
        }
        
        private func insert(day: Pollen.Day, in cellViewModels: [Pollen.City: [ReadingCollectionViewCell.ViewModel]], isPrevious: Bool) -> [Pollen.City: [ReadingCollectionViewCell.ViewModel]] {
            var mutableCellViewModels = cellViewModels
            for cityReading in day.cityReadings {
                for reading in cityReading.readings {
                    mutableCellViewModels = insert(
                        value: reading.displayableValue,
                        from: day.date,
                        of: reading.sort,
                        for: cityReading.city,
                        in: mutableCellViewModels,
                        isPrevious: isPrevious)
                }
            }
            
            return mutableCellViewModels
        }
        
        private func insert(value: String, from date: Date, of sort: Pollen.Sort, for city: Pollen.City, in cellViewModels: [Pollen.City: [ReadingCollectionViewCell.ViewModel]], isPrevious: Bool) -> [Pollen.City: [ReadingCollectionViewCell.ViewModel]] {
            let newReading = ReadingCollectionViewCell.ViewModel.Reading(value: value, date: date)
            var viewModels = cellViewModels[city] ?? []
            if let idx = viewModels.index(where: { $0.city == city && $0.sort == sort }) {
                let existingViewModel = viewModels[idx]
                let newViewModel = ReadingCollectionViewCell.ViewModel(
                    sort: sort,
                    city: city,
                    latestReading: isPrevious ? existingViewModel.latestReading : newReading,
                    previousReading: isPrevious ? newReading : existingViewModel.previousReading)
                viewModels.remove(at: idx)
                viewModels.append(newViewModel)
            } else {
                viewModels.append(ReadingCollectionViewCell.ViewModel(
                    sort: sort,
                    city: city,
                    latestReading: isPrevious ? nil : newReading,
                    previousReading: isPrevious ? newReading : nil))
            }
            
            var mutableCellViewModels = cellViewModels
            mutableCellViewModels[city] = viewModels.sorted(isOrderedBefore: { $0.sort.order < $1.sort.order })
            return mutableCellViewModels
        }
    }
}
