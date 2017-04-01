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

protocol Mapper {
    associatedtype D
    func map<T: Decodable>(data: D, toObject type: T) -> Result<T,NSError>
    func mapToArray<T: Decodable>(data: D, toObject type: T) -> Result<[T],NSError>
}
