//
//  RecordStats.swift
//  Jogger
//
//  Created by Kamil Badyla on 02.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation

struct RecordStats {
    let avgSpeed: Measurement<UnitSpeed>
    let avgDistance: Measurement<UnitLength>
    
    init(records: [Record]) {
        let t = (Double(0), Double(0))
        let (timeSum, distanceSum) = records.reduce(t) { (t, r) -> (Double, Double) in
            return (t.0 + r.time, t.1 + Double(r.distance))
        }
        self.avgSpeed = Measurement(value: timeSum > 0 ? distanceSum / timeSum : 0, unit: UnitSpeed.metersPerSecond)
        self.avgDistance = Measurement(value: records.count > 0 ? distanceSum / Double(records.count) : 0, unit: UnitLength.meters)
    }
}
