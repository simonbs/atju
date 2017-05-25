//
//  Config.swift
//  Atju
//
//  Created by Simon Støvring on 03/07/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

class Config {
    static let shared = Config()
    let url: URL
    
    private init() {
        guard let path = Bundle.main.path(forResource: "AtjuConfig", ofType: "plist") else {
            fatalError("AtjuConfig.plist not found. Be sure to copy Config/AjtuConfig.example.plist to Config/AtjuConfig.plist and enter the appropriate values.")
        }
        
        guard let config = NSDictionary(contentsOfFile: path) else {
            fatalError("Unable to parse config file at Config/AtjuConfig.plist")
        }
        
        guard let absoluteUrl = config["url"] as? String, let url = URL(string: absoluteUrl) else {
            fatalError("Unsupported URL for the 'url' key in the config file.")
        }
        
        self.url = url
    }
}
