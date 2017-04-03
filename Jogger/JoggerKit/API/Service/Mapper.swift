//
//  Mapper.swift
//  Jogger
//
//  Created by Kamil Badyla on 31.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import Himotoki
import Result
import SwiftDate

protocol Mapper {
    associatedtype D
    func map<T: Decodable>(data: D, toObject type: T.Type) -> Result<T,NSError>
    func mapToArray<T: Decodable>(data: D, toArrayWith type: T.Type) -> Result<[T],NSError>
}

class Transformers {
    public static let isoInternetDateTime = Transformer<String, Date> { dateString throws -> Date in
        if let date = DateInRegion().formatters.isoFormatter(options: [.withInternetDateTime]).date(from: dateString) {
            return date
        }
        
        throw customError("Invalid datetime string: \(dateString)")
    }
}

enum MapError {
    case unknownJSON
    
    var code: Int {
        switch self {
        case .unknownJSON:
            return 10005
        }
    }
    
    var nsError: NSError {
        return NSError(domain: NSError.joggerDomain, code: self.code, userInfo: nil)
    }
}


