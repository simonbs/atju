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
        private let client = AtjuClient(baseURL: Config.shared.url)
        private(set) var cellViewModels: [Pollen.City: [ReadingCollectionViewCell.ViewModel]] = [:]
        var selectedCity: Pollen.City {
            get {
                return SettingsStore().selectedCity
            }
            set {
                var store = SettingsStore()
                store.selectedCity = newValue
                UAirship.push().tags = [ newValue.title ]
                UAirship.push().updateRegistration()
            }
        }
        
        var cellViewModelsForSelectedCity: [ReadingCollectionViewCell.ViewModel] {
            return cellViewModels[selectedCity] ?? []
        }
        
        var prognoseViewModel: PrognoseReusableView.ViewModel?
        
        func getPollen(update: @escaping (() -> Void), failure: @escaping ((AtjuClient.Error) -> Void)) {
            client.getPollen(success: { [weak self] pollen in
                guard let strongSelf = self else { return }
                DispatchQueue.global(qos: .background).async {
                    var cellViewModels: [Pollen.City: [ReadingCollectionViewCell.ViewModel]] = [:]
                    cellViewModels = strongSelf.insert(day: pollen.latest, in: cellViewModels, isPrevious: false)
                    if let previous = pollen.previous {
                        cellViewModels = strongSelf.insert(day: previous, in: cellViewModels, isPrevious: true)
                    }
                    
                    self?.cellViewModels = cellViewModels
                    
                    if let prognoseText = pollen.latest.prognose {
                        self?.prognoseViewModel = PrognoseReusableView.ViewModel(text: prognoseText)
                    } else {
                        self?.prognoseViewModel = nil
                    }
                    
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
            mutableCellViewModels[city] = viewModels.sorted(by: { $0.sort.order < $1.sort.order })
            return mutableCellViewModels
        }
    }
}
