//
//  Pollen.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Pollen {
    struct Day {
        let date: Date
        let prognose: String?
        let cityReadings: [CityReadings]
        
        init?(json: SwiftyJSON.JSON) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            guard let date = json["date"].string => dateFormatter.date else { return nil }
            self.date = date
            self.prognose = json["prognose"].string
            self.cityReadings = json["cities"].array?.flatMap(CityReadings.init) ?? []
        }
    }
    
    enum City: String {
        case copenhagen = "København"
        case viborg = "Viborg"
    }
    
    struct CityReadings {
        let city: City
        let readings: [Reading]
        
        init?(json: SwiftyJSON.JSON) {
            guard let city = json["name"].string => City.init else { return nil }
            self.city = city
            self.readings = json["readings"].array?.flatMap(Reading.init) ?? []
        }
    }
    
    struct Reading {
        let sort: Sort
        let value: String
        
        init?(json: SwiftyJSON.JSON) {
            guard let sort = json["name"].string => Sort.init else { return nil }
            guard let value = json["value"].string else { return nil }
            self.sort = sort
            self.value = value
        }
    }
    
    enum Sort: String {
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
    
    init?(json: SwiftyJSON.JSON) {
        guard let latest = json["latest"] => Day.init else { return nil }
        self.latest = latest
        self.previous = json["previous"] => Day.init
    }
}
