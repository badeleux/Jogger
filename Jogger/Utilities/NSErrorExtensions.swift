//
//  NSErrorExtensions.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation

enum JoggerErrorCode: Int {
    case unauthenticated = 401
    case validation = -10001
    
}

extension NSError {
    static let joggerDomain = Bundle.main.bundleIdentifier!
    static let unauthenticated = NSError(domain: NSError.joggerDomain, code: JoggerErrorCode.unauthenticated.rawValue, userInfo: nil)
    
    static func customError(code: JoggerErrorCode, localizedDescription: String) -> NSError {
        return NSError(domain: NSError.joggerDomain, code: code.rawValue, userInfo: [ NSLocalizedDescriptionKey : localizedDescription])
    }
}
