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
    
    private let session: URLSession = .shared
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getPollen(success: @escaping ((Pollen) -> Void), failure: @escaping ((Error) -> Void)) {
        let url = baseURL.appendingPathComponent("/dmi/pollen")
        let task = session.dataTask(with: url) { data, resp, error in
            if error != nil {
                DispatchQueue.main.async {
                    failure(.failedLoading)
                }
                return
            }
            
            if let data = data {
                do {
                    let json = try JSON(data: data)
                    let pollen = try Pollen(json: json)
                    DispatchQueue.main.async {
                        success(pollen)
                    }
                } catch {
                    DispatchQueue.main.async {
                        failure(.failedParsing)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    failure(.unknown)
                }
            }
        }
        task.resume()
    }
}
