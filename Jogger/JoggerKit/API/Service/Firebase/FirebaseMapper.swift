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

protocol AnyValueContainable {
    var value: Any? { get }
    var children: NSEnumerator { get }
}

extension FIRDataSnapshot: AnyValueContainable {}

class FirebaseMapper: Mapper {
    typealias D = AnyValueContainable
    func map<T : Decodable>(data: D, toObject type: T.Type) -> Result<T, NSError> {
        return .failure(NSError.unknownError())
    }
    
    func mapToArray<T : Decodable>(data: D, toArrayWith type: T.Type) -> Result<[T], NSError> {
        return Result(attempt: { () -> [T] in
            return try [T].decode(data.children.allObjects.map({ (a: Any) -> [String : Any] in
                if let snapshot = a as? FIRDataSnapshot, let dict = snapshot.value as? [String : Any] {
                    var d = dict
                    d["id"] = snapshot.key
                    return d
                }
                else {
                    return [:]
                }
            }))
        })
    }
}
