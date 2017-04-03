//
//  RecordViewModelEditable.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol RecordViewModelEditable {
    //Inputs
    var recordID: MutableProperty<RecordID?> { get }
    var time: MutableProperty<String?> { get }
    var distance: MutableProperty<String?> { get }
    var date: MutableProperty<Date?> { get }
    func save(forUserId userId: UserId) -> SignalProducer<Bool, NSError>
    
}

extension RecordViewModelEditable {
    func createRecord() -> Result<Record, NSError> {
        if let d = date.value,
            let timeString = time.value,
            let t = TimeInterval(timeString),
            let distString = distance.value,
            let dist = Float(distString) {
            return Result.success(Record(recordID: self.recordID.value, date: d, distance: dist, time: t))
        }
        return Result.failure(NSError.customError(code: .validation, localizedDescription: "Can't create record object - one of the values is nil"))
    }
}
