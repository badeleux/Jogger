//
//  AuthService.swift
//  Jogger
//
//  Created by Kamil Badyla on 22.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol AuthService: APIService {
    func signIn(email: String, password: String) -> SignalProducer<User, NSError>
    func signUp(email: String, password: String) -> SignalProducer<User, NSError>
    func signOut() -> SignalProducer<Bool, NSError>
}
