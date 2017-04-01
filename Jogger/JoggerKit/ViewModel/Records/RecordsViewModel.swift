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
    
    func refresh() {
        
    }
    
    //OUTPUTS
    let resourceData: Signal<[Record], NoError>
    let resourceStatus: Signal<ActionStatus<NSError>, NoError>
    
    
    private let recordsService: RecordsService
    init(recordsService: RecordsService) {
        self.recordsService = recordsService
        self.resourceData = .empty
        self.resourceStatus = .empty
    }
}
