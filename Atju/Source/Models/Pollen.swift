//
//  Pollen.swift
//  Atju
//
//  Created by Simon Støvring on 17/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import Freddy

struct Pollen {
    struct Day {
        let date: Date
        let prognose: String?
        let cityReadings: [CityReadings]
    }
    
    enum City: String {
        case copenhagen = "København"
        case viborg = "Viborg"
    }
    
    struct CityReadings {
        let city: City
        let readings: [Reading]
    }
    
    struct Reading {
        let sort: Sort
        let value: String
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
}

extension Pollen.Day: JSONDecodable {
    init(json: JSON) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "Zulu")
        date = try json.getDate(at: "date", using: dateFormatter)
        prognose = try json.getString(at: "prognose")
        cityReadings = try json.decodedArray(at: "cities")
    }
}

extension Pollen.City: JSONDecodable {
    public init(json: JSON) throws {
        self = try Pollen.City.from(json)
    }
    
    private static func from(_ json: JSON) throws -> Pollen.City {
        let rawValue = try json.getString()
        guard let value = Pollen.City(rawValue: rawValue) else {
            throw JSON.Error.valueNotConvertible(value: json, to: Pollen.City.self)
        }
        return value
    }
}

extension Pollen.CityReadings: JSONDecodable {
    init(json: JSON) throws {
        city = try json.decode(at: "name")
        readings = try json.decodedArray(at: "readings")
    }
}

extension Pollen.Reading: JSONDecodable {
    init(json: JSON) throws {
        sort = try json.decode(at: "name")
        value = try json.getString(at: "value")
    }
}

extension Pollen.Sort: JSONDecodable {
    public init(json: JSON) throws {
        self = try Pollen.Sort.from(json)
    }
    
    private static func from(_ json: JSON) throws -> Pollen.Sort {
        let rawValue = try json.getString()
        guard let value = Pollen.Sort(rawValue: rawValue) else {
            throw JSON.Error.valueNotConvertible(value: json, to: Pollen.Sort.self)
        }
        return value
    }
}

extension Pollen: JSONDecodable {
    init(json: JSON) throws {
        latest = try json.decode(at: "latest")
        previous = try? json.decode(at: "previous")
    }
}
