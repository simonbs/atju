//
//  SettingsStore.swift
//  Atju
//
//  Created by Simon Støvring on 28/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

struct SettingsStore {
    private struct Keys {
        static let selectedCity = "selectedCity"
    }
    
    private let store: UserDefaults

    init(store: UserDefaults = .standard()) {
        self.store = store
    }
    
    var selectedCity: Pollen.City {
        get {
            return Pollen.City(rawValue: store.integer(forKey: Keys.selectedCity)) ?? .copenhagen
        }
        set {
            store.set(newValue.rawValue, forKey: Keys.selectedCity)
        }
    }
}
