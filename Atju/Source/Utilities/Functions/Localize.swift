//
//  Localize.swift
//  Atju
//
//  Created by Simon Støvring on 21/03/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation

typealias LazyVarArgClosure = (Void) -> CVarArg

func localize(_ key: String) -> String {
    return localize(key, tableName: nil)
}

func localize(_ key: String, tableName: String?, comment: String = "") -> String {
    return NSLocalizedString(key, tableName: tableName, bundle: Bundle.main, value: key, comment: comment)
}

func localizeFormatted(_ key: String, _ args: [CVarArg]) -> String {
    if args.count == 0 {
        return NSLocalizedString(key, bundle: Bundle.main, value: key, comment: "")
    }
    
    return withVaList(args) { (pointer: CVaListPointer) -> String in
        return NSString(format: localize(key), arguments: pointer) as String
    }
}
