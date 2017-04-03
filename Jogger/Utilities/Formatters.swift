//
//  Formatters.swift
//  Jogger
//
//  Created by Kamil Badyla on 02.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation

class Formatter {
    static func runSpeedFormat(speed: Measurement<UnitSpeed>) -> String {
        return MeasurementFormatter().string(from: speed)
    }
    
    static func runDistanceFormat(dist: Measurement<UnitLength>) -> String {
        return MeasurementFormatter().string(from: dist)
    }
    
    static func runDurationFormat(dist: Measurement<UnitDuration>) -> String {
        return MeasurementFormatter().string(from: dist)
    }
}
