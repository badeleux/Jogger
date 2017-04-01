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

typealias RecordID = String

struct Record: Decodable, Encodable {
    let recordID: String?
    let date: Date
    let distance: Float
    let time: TimeInterval
    
    init(recordID: String? = nil, date: Date, distance: Float, time: TimeInterval) {
        self.recordID = recordID
        self.date = date
        self.distance = distance
        self.time = time
    }
    
    static func decode(_ e: Extractor) throws -> Record {
        return try Record(recordID: e <|? "id",
                          date: Transformers.isoInternetDateTime.apply(e <| "date"),
                          distance: e <| "distance",
                          time: e <| "time")
    }
    
    func encode() -> Any? {
        return ["date" : self.date.string(format: .iso8601(options: [.withInternetDateTime])),
                "distance" : distance,
                "time" : time]
    }
    
    func avgSpeed() -> Double {
        return Double(self.distance) / self.time
    }

}
