//
//  Localize.swift
//  Atju
//
//  Created by Simon Støvring on 21/03/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

typealias LazyVarArgClosure = (Void) -> CVarArg

/**
 Retrieve localized string for the specified key.
 
 - parameter key: Key to retrieve localized string for.
 
 - returns: Localized string.
 */
func localize(_ key: String) -> String {
    return localize(key, tableName: nil)
}

/**
 Retrieve localized string for the specified key in the specified table.
 
 - parameter key:       Key to retrieve localized string for.
 - parameter tableName: Table to look up key in.
 - parameter comment:   Optional comment for the localization.
 
 - returns: Localized string.
 */
func localize(_ key: String, tableName: String?, comment: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, bundle: Bundle.main, value: key, comment: comment)
}

/**
 Retrieve a localized string and format it using the specified arguments.
 
 - parameter key:  Key to retrieve localized string for.
 - parameter tableName: Table to look up key in.
 
 - returns: Localized string.
 */
func localizeFormatted(_ key: String, _ args: [CVarArg]) -> String {
    if args.count == 0 {
        return NSLocalizedString(key, bundle: Bundle.main, value: key, comment: "")
    }
    
    return withVaList(args) { (pointer: CVaListPointer) -> String in
        return NSString(format: localize(key), arguments: pointer) as String
    }
}
