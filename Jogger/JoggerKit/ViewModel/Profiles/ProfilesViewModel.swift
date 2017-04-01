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
    
    private let lifetime: (Lifetime, Lifetime.Token)

    init(profilesService: ProfileService) {
        self.profilesService = profilesService
        let resourceStatusMutProperty = MutableProperty<ActionStatus<NSError>>(.none)
        let resourceProducer = self.refreshProperty.signal.flatMap(.latest, transform: { _ -> SignalProducer<[Profile], NoError> in
            return profilesService.profiles()
                .on(statusChanged: { resourceStatusMutProperty.value = $0 })
                .ignoreError()
        })
        let lifeTime = Lifetime.make()
        self.resourceData = Signal { o in return resourceProducer.logEvents().observe(o, during: lifeTime.lifetime)}
        self.lifetime = lifeTime
        self.resourceStatus = Property(capturing: resourceStatusMutProperty)
    }
    
    let refreshProperty = MutableProperty<()>(())
    func refresh() {
        self.refreshProperty.value = ()
    }
    
    let resourceData: Signal<[Profile], NoError>
    let resourceStatus: Property<ActionStatus<NSError>>
    
    
}
