//
//  ReadingsViewModel.swift
//  Atju
//
//  Created by Simon Støvring on 19/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import AirshipKit

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
        enum Error: Swift.Error {
            case cachedPollenUnavailable
        }
        
        private(set) var cellViewModels: [Pollen.City: [ReadingCollectionViewCell.ViewModel]] = [:]
        private let settingsStore = SettingsStore()
        private let pollenStore = PollenStore()
        var selectedCity: Pollen.City {
            get { return settingsStore.selectedCity  }
            set {
                settingsStore.selectedCity = newValue
                UAirship.push().tags = [ newValue.title ]
                UAirship.push().updateRegistration()
            }
        }
        var cellViewModelsForSelectedCity: [ReadingCollectionViewCell.ViewModel] {
            return cellViewModels[selectedCity] ?? []
        }
        var prognoseViewModel: PrognoseReusableView.ViewModel?
        var hasCachedPollen: Bool {
            return pollenStore.cachedPollenJSONData != nil
        }
        
        func loadCachedPollen(completion: @escaping (Result<Void>) -> Void) {
            guard let cachedPollen = pollenStore.decodeCachedPollenJSONData() else {
                completion(.error(Error.cachedPollenUnavailable))
                return
            }
            populate(from: cachedPollen) {
                completion(.value())
            }
        }
        
        func refresh(completion: @escaping (Result<Void>) -> Void) {
            pollenStore.refresh { [weak self] result in
                switch result {
                case .value(let pollen):
                    self?.populate(from: pollen) {
                        completion(.value())
                    }
                case .error(let error):
                    completion(.error(error))
                }
            }
        }
        
        private func populate(from pollen: Pollen, completion: @escaping (Void) -> Void) {
            DispatchQueue.global(qos: .background).async {
                var cellViewModels: [Pollen.City: [ReadingCollectionViewCell.ViewModel]] = [:]
                cellViewModels = self.insert(day: pollen.latest, in: cellViewModels, isPrevious: false)
                if let previous = pollen.previous {
                    cellViewModels = self.insert(day: previous, in: cellViewModels, isPrevious: true)
                }
                self.cellViewModels = cellViewModels
                if let prognoseText = pollen.latest.prognose {
                    self.prognoseViewModel = PrognoseReusableView.ViewModel(text: prognoseText)
                } else {
                    self.prognoseViewModel = nil
                }
                DispatchQueue.main.async {
                    completion()
                }
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
            mutableCellViewModels[city] = viewModels.sorted(by: { $0.sort.order < $1.sort.order })
            return mutableCellViewModels
        }
    }
}
