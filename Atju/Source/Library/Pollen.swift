//
//  Pollen.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

struct Pollen: Codable {
    struct Day: Codable {
        private enum CodingKeys: String, CodingKey {
            case date
            case prognose
            case cityReadings = "cities"
        }
        
        let date: Date
        let prognose: String?
        let cityReadings: [CityReadings]
    }
    
    enum City: String, Codable {
        case copenhagen = "København"
        case viborg = "Viborg"
    }
    
    struct CityReadings: Codable {
        private enum CodingKeys: String, CodingKey {
            case city = "name"
            case readings
        }
        
        let city: City
        let readings: [Reading]
    }
    
    struct Reading: Codable {
        private enum CodingKeys: String, CodingKey {
            case sort = "name"
            case value
        }
        
        let sort: Sort
        let value: String
    }
    
    enum Sort: String, Codable {
        case cladosporium = "Cladosporium"
        case græs = "Græs"
        case bynke = "Bynke"
        case birk = "Birk"
        case el = "El"
        case elm = "Elm"
        case hassel = "Hassel"
        case alternaria = "Alternaria"
    }
    
    let latest: Day
    let previous: Day?
}
