//
//  SignInViewModel.swift
//  Jogger
//
//  Created by Kamil Badyla on 22.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public class SignInViewModel {
    // MARK: - DI
    let authService: AuthService
    
    
    // MARK: - Inputs
    let credentials = MutableProperty<(String, String)?>(nil)
    func signIn(email: String, password: String) {
        self.credentials.value = (email, password)
    }
    
    // MARK: - Outputs
    
    var signInActionStatus = MutableProperty<ActionStatus<NSError>>(.none)
    let user = MutableProperty<User?>(nil)
    
    public init(authService: AuthService) {
        self.authService = authService
        self.user <~ self.credentials.signal
                        .skipNil()
                        .flatMap(.latest, transform: { (c: (String, String)) -> SignalProducer<User, NoError> in
                            return authService.signIn(email: c.0, password: c.1)
                                        .on(statusChanged: {[weak self] (status: ActionStatus<NSError>) in
                                            self?.signInActionStatus.value = status
                                        })
                                        .flatMapError { _ in SignalProducer<User, NoError>.empty }
                        })
        
    }
}
