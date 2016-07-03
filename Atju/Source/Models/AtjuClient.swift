//
//  AtjuClient.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import SwiftyJSON

class AtjuClient {
    enum Error: ErrorProtocol {
        case unableToCreateUrl
        case failedLoading
        case failedParsing
        case unknown
    }
    
    private let session: URLSession = .shared()
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getPollen(success: ((Pollen) -> Void), failure: ((Error) -> Void)) {
        let url: URL
        do {
            url = try baseURL.appendingPathComponent("/dmi/pollen")
        } catch {
            failure(.unableToCreateUrl)
            return
        }
        
        let task = session.dataTask(with: url) { data, resp, error in
            if error != nil {
                DispatchQueue.main.async {
                    failure(.failedLoading)
                }
                return
            }
            
            if let data = data {
                let json = SwiftyJSON.JSON(data: data)
                if json.error != nil {
                    DispatchQueue.main.async {
                        failure(.failedParsing)
                    }
                    return
                }
                
                if let pollen = json => Pollen.init {
                    DispatchQueue.main.async {
                        success(pollen)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    failure(.failedParsing)
                }
                return
            }
            
            DispatchQueue.main.async {
                failure(.unknown)
            }
        }
        task.resume()
    }
}
