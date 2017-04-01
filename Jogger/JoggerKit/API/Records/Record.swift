//
//  Record.swift
//  Jogger
//
//  Created by Kamil Badyla on 31.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import Himotoki
import SwiftDate

struct Record: Decodable {
    let date: Date
    let distance: Float
    let time: TimeInterval
    static func decode(_ e: Extractor) throws -> Record {
        return try Record(date: Transformers.isoInternetDateTime.apply(e <| "date"), distance: e <| "distance", time: e <| "time")
    }

}
