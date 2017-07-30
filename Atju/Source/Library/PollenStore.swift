//
//  PollenStore.swift
//  Atju
//
//  Created by Simon Støvring on 27/05/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import Foundation

class PollenStore {
    private struct Keys {
        static let pollenJSONData = "pollenJSONData"
    }
    
    private let store: UserDefaults
    private let client = AtjuClient(baseURL: Config().url)
    
    init(store: UserDefaults = .standard) {
        self.store = store
        cachedPollenJSONData = store.data(forKey: Keys.pollenJSONData)
    }
    
    var cachedPollenJSONData: Data? {
        didSet {
            if cachedPollenJSONData == nil {
                store.removeObject(forKey: Keys.pollenJSONData)
            } else {
                store.set(cachedPollenJSONData, forKey: Keys.pollenJSONData)
            }
        }
    }
    
    func decodeCachedPollenJSONData() -> Pollen? {
        guard let cachedPollenJSONData = cachedPollenJSONData else { return nil }
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "Zulu")
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            return try jsonDecoder.decode(Pollen.self, from: cachedPollenJSONData)
        } catch {
            // The data could not be decoded, so we remove it.
            // We don't want to attempt decoding again it in the future.
            self.cachedPollenJSONData = nil
            return nil
        }
    }
    
    func refresh(completion: @escaping (ValueResult<Pollen>) -> Void) {
        client.getPollen { [weak self] result in
            switch result {
            case .value(let response):
                DispatchQueue.global(qos: .background).async {
                    self?.cachedPollenJSONData = response.data
                }                
                completion(.value(response.value))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
