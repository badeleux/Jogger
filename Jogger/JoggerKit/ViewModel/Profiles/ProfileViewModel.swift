//
//  ProfileViewModel.swift
//  Jogger
//
//  Created by Kamil Badyla on 02.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ProfileViewModel {
    let profileService: ProfileService
    let rolesService: UserRoleService
    
    init(profileService: ProfileService, rolesService: UserRoleService) {
        self.profileService = profileService
        self.rolesService = rolesService
        let role = self.profileProperty.signal.skipNil().flatMap(.latest) { (profile: Profile) -> SignalProducer<UserRole, NoError> in
            return rolesService.role(forUserId: profile.userID).ignoreError()
        }
        self.roleProperty = Property(initial: .regular, then: role)
    }
    
    let profileProperty = MutableProperty<Profile?>(nil)
    func set(profile: Profile) {
        self.profileProperty.value = profile
    }
    
    let roleProperty: Property<UserRole>
    
    func set(role: UserRole) -> SignalProducer<UserRole, NSError> {
        return self.profileProperty.producer.skipNil().take(first: 1).flatMap(.latest) { [weak self] (p: Profile) -> SignalProducer<UserRole, NSError> in
            return self?.rolesService.setRole(role: role, forUserId: p.userID) ?? .empty
        }
    }
    
    
    
}
