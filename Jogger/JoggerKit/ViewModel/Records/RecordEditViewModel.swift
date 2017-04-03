//
//  RecordEditViewModel.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift

class RecordEditViewModel: RecordViewModelEditable {
    var recordID = MutableProperty<RecordID?>(nil)
    let distance = MutableProperty<String?>(nil)
    let time = MutableProperty<String?>(nil)
    let date = MutableProperty<Date?>(nil)
    
    private let recordsService: RecordsService
    init(recordsService: RecordsService) {
        self.recordsService = recordsService
    }
    
    func save(forUserId userId: UserId) -> SignalProducer<Bool, NSError> {
        let result = self.createRecord()
        if let record = result.value {
            return self.recordsService.update(record: record, forUserId: userId).map { _ in true }
        }
        else {
            return SignalProducer.init(error: result.error!)
        }
    }
}
