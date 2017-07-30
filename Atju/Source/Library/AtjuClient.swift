//
//  AtjuClient.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

class AtjuClient {
    enum Error: Swift.Error {
        case failedLoading
        case failedParsing(Swift.Error)
        case unknown
    }
    
    struct Response<T> {
        let data: Data
        let value: T
    }
    
    private let session: URLSession = .shared
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getPollen(completion: @escaping (ValueResult<Response<Pollen>>) -> Void) {
        let url = baseURL.appendingPathComponent("/dmi/pollen")
        let task = session.dataTask(with: url) { data, resp, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.error(AtjuClient.Error.failedLoading))
                }
                return
            }
            if let data = data {
                do {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    dateFormatter.timeZone = TimeZone(abbreviation: "Zulu")
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let pollen = try decoder.decode(Pollen.self, from: data)
                    DispatchQueue.main.async {
                        completion(.value(Response(data: data, value: pollen)))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.error(AtjuClient.Error.failedParsing(error)))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.error(AtjuClient.Error.unknown))
                }
            }
        }
        task.resume()
    }
}
