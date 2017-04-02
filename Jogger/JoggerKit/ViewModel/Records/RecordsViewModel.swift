//
//  RecordsViewModel.swift
//  Jogger
//
//  Created by Kamil Badyla on 31.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result


class RecordsViewModel: ResourceViewModelInput, ResourceViewModelOutput {
    //INPUTS
    let userIdProperty = MutableProperty<UserId?>(nil)
    func userId(uid: UserId) {
        self.userIdProperty.value = uid
    }
    
    let refreshProperty = MutableProperty<()>(())
    func refresh() {
        self.refreshProperty.value = ()
    }
    
    let dateRange = MutableProperty<ClosedRange<Date>?>(nil)
    
    func delete(recordID: RecordID) -> SignalProducer<Bool, NSError> {
        return self.userIdProperty.producer.skipNil().take(first: 1).flatMap(.latest) { (uid: UserId) -> SignalProducer<Bool, NSError> in
            return self.recordsService.delete(recordID: recordID, forUserId: uid).map { _ in true }
        }.on(completed: { [weak self] in
            self?.refresh()
        })
    }
    
    //OUTPUTS
    let records: Property<[Record]>
    let resourceData: Property<[Record]>
    let resourceStatus: Property<ActionStatus<NSError>>
    let datesFilterValues: Property<[Date]>
    
    
    
    private let recordsService: RecordsService
    init(recordsService: RecordsService) {
        self.recordsService = recordsService
        let resourceStatusMutProperty = MutableProperty<ActionStatus<NSError>>(.none)
        let recordsProducer = SignalProducer.combineLatest(self.refreshProperty.producer, self.userIdProperty.producer.skipNil()).flatMap(.latest, transform: { (t: ((), UserId)) -> SignalProducer<[Record], NoError> in
            return recordsService.records(forUserId: t.1)
                .map({ (records: [Record]) -> [Record] in
                    return records.sorted(by: { $0.0.date > $0.1.date })
                })
                .on(statusChanged: { resourceStatusMutProperty.value = $0 })
                .ignoreError()
        })
        self.records = Property(initial: [], then: recordsProducer)
        self.resourceData = Property(initial: [], then: SignalProducer.combineLatest(records.producer, self.dateRange.producer)
            .map { t in
                if let dateRange = t.1 {
                    return t.0.filter { dateRange.contains($0.date) }
                }
                else {
                    return t.0
                }
            })
        self.resourceStatus = Property(capturing: resourceStatusMutProperty)
        self.datesFilterValues = Property(initial: [], then: self.records.producer.map { $0.map { $0.date }.reversed() })
    }
}
