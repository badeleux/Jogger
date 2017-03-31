//
//  User.swift
//  Jogger
//
//  Created by Kamil Badyla on 22.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation

public typealias UserId = String

public protocol User {
    var userId: UserId { get }
    var email: String? { get }
}
