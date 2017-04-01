//
//  FirebaseService.swift
//  Jogger
//
//  Created by Kamil Badyla on 31.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import Himotoki
import Firebase
import Result

class FirebaseMapper: Mapper {
    func map<T : Decodable>(data: FIRDataSnapshot, toObject type: T) -> Result<T, NSError> {
        return .failure(NSError.unknownError())
    }
    
    func mapToArray<T : Decodable>(data: FIRDataSnapshot, toObject type: T) -> Result<[T], NSError> {
        return .failure(NSError.unknownError())
    }
}
