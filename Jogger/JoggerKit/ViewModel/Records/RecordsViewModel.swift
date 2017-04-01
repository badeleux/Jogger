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
    
    func delete(recordID: RecordID) -> SignalProducer<Bool, NSError> {
        return self.userIdProperty.producer.skipNil().take(first: 1).flatMap(.latest) { (uid: UserId) -> SignalProducer<Bool, NSError> in
            return self.recordsService.delete(recordID: recordID, forUserId: uid).map { _ in true }
        }.on(completed: { [weak self] in
            self?.refresh()
        })
    }
    
    private let lifetime: (Lifetime, Lifetime.Token)
    
    //OUTPUTS
    let resourceData: Signal<[Record], NoError>
    let resourceStatus: Property<ActionStatus<NSError>>
    
    
    
    private let recordsService: RecordsService
    init(recordsService: RecordsService) {
        self.recordsService = recordsService
        let resourceStatusMutProperty = MutableProperty<ActionStatus<NSError>>(.none)
        let resourceProducer = SignalProducer.combineLatest(self.refreshProperty.producer, self.userIdProperty.producer.skipNil()).flatMap(.latest, transform: { (t: ((), UserId)) -> SignalProducer<[Record], NoError> in
            return recordsService.records(forUserId: t.1)
                .on(statusChanged: { resourceStatusMutProperty.value = $0 })
                .ignoreError()
        })
        let lifeTime = Lifetime.make()
        self.resourceData = Signal { o in return resourceProducer.logEvents().observe(o, during: lifeTime.lifetime)}
        self.lifetime = lifeTime
        self.resourceStatus = Property(capturing: resourceStatusMutProperty)
    }
}
