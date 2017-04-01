//
//  ProfileViewModel.swift
//  Jogger
//
//  Created by Kamil Badyla on 02.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift

class ProfileViewModel {
    let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
    
    let profileProperty = MutableProperty<Profile?>(nil)
    func set(profile: Profile) {
        self.profileProperty.value = profile
    }
    
    
}
