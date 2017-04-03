//
//  UserRoleService.swift
//  Jogger
//
//  Created by Kamil Badyla on 30.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol UserRoleService {
    func role(forUserId userId: UserId) -> SignalProducer<UserRole, NSError>
    func setRole(role: UserRole, forUserId userId: UserId) -> SignalProducer<UserRole, NSError>
}
