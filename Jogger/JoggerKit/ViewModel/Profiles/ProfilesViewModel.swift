//
//  ProfilesViewModel.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ProfilesViewModel: ResourceViewModelInput, ResourceViewModelOutput {
    let profilesService: ProfileService

    init(profilesService: ProfileService) {
        self.profilesService = profilesService
        let resourceStatusMutProperty = MutableProperty<ActionStatus<NSError>>(.none)
        let resourceProducer = self.refreshProperty.signal.flatMap(.latest, transform: { _ -> SignalProducer<[Profile], NoError> in
            return profilesService.profiles()
                .on(statusChanged: { resourceStatusMutProperty.value = $0 })
                .ignoreError()
        })
        self.resourceData = Property(initial: [], then: resourceProducer)
        self.resourceStatus = Property(capturing: resourceStatusMutProperty)
    }
    
    let refreshProperty = MutableProperty<()>(())
    func refresh() {
        self.refreshProperty.value = ()
    }
    
    let resourceData: Property<[Profile]>
    let resourceStatus: Property<ActionStatus<NSError>>
    
    
}
