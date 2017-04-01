//
//  ProfileService.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol ProfileService {
    func profiles() -> SignalProducer<[Profile], NSError>
    func add(profile: Profile) -> SignalProducer<Profile, NSError>
}
