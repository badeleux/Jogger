//
//  RecordAddViewModel.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift

class RecordAddViewModel: RecordViewModelEditable {
    let distance = MutableProperty<String?>(nil)
    let time = MutableProperty<String?>(nil)
    let date = MutableProperty<Date?>(nil)
    
    private let recordsService: RecordsService
    private let userAuthViewModel: UserAuthViewModel
    init(recordsService: RecordsService, userAuthViewModel: UserAuthViewModel) {
        self.recordsService = recordsService
        self.userAuthViewModel = userAuthViewModel
    }
    
    func save() -> SignalProducer<Bool, NSError> {
        let result = self.createRecord()
        if let record = result.value {
            return self.userAuthViewModel.currentUser.producer.take(first: 1).flatMap(.latest, transform: { (u: User?) -> SignalProducer<Bool, NSError> in
                if let user = u {
                    return self.recordsService.add(record: record, forUserId: user.userId).map { _ in true }
                }
                else {
                    return SignalProducer.init(error: NSError.unauthenticated)
                }
            })
        }
        else {
            return SignalProducer.init(error: result.error!)
        }
    }
    
}
