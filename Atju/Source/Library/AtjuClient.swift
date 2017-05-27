//
//  AtjuClient.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import Freddy

class AtjuClient {
    enum Error: Swift.Error {
        case failedLoading
        case failedParsing
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
    
    func getPollen(completion: @escaping (Result<Response<Pollen>>) -> Void) {
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
                    let json = try JSON(data: data)
                    let pollen = try Pollen(json: json)
                    DispatchQueue.main.async {
                        completion(.value(Response(data: data, value: pollen)))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.error(AtjuClient.Error.failedParsing))
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
