//
//  UserAuthViewModel.swift
//  Jogger
//
//  Created by Kamil Badyla on 28.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import Swinject
import Result

enum RootViewState {
    case logIn, regular, manager, admin
}

extension RootViewState: Equatable {}

func ==(l: RootViewState, r: RootViewState) -> Bool {
    return l.hashValue == r.hashValue
}

class UserAuthViewModel {
    let authService: AuthService
    private let userViewModelProperty = MutableProperty<UserViewModel?>(nil)
    private let userAuthenticatedProperty = MutableProperty<Bool>(false)
    private let userRoleProperty = MutableProperty<UserRole>(.regular)
    
    init(authService: AuthService, resolver: Resolver, rolesService: UserRoleService) {
        self.authService = authService
        
        rootViewState = Property(initial: .logIn, then: Signal.combineLatest(self.userAuthenticatedProperty.signal, self.userRoleProperty.signal).map { (t: (Bool, UserRole)) -> RootViewState in
            if !t.0 {
                return .logIn
            }
            else {
                switch t.1 {
                case .regular:
                    return .regular
                case .userManager:
                    return .manager
                case .admin:
                    return .admin
                }
            }
        })
        
        userAuthenticatedProperty <~ authService.currentUser.producer.map { $0 != nil }
        userViewModelProperty <~ authService.currentUser.producer.map { resolver.resolve(UserViewModel.self, argument: $0) }
        userRoleProperty <~ authService.currentUser.producer.flatMap(.latest, transform: { (user: User?) -> SignalProducer<UserRole, NoError> in
            if let u = user {
                return rolesService.role(forUserId: u.userId).ignoreError()
            }
            else {
                return .init(value:.regular)
            }
        })
        currentUser = Property(capturing: authService.currentUser)
        

        
    }
    
    // MARK: - Outputs
    let rootViewState: Property<RootViewState>
    let currentUser: Property<User?>
    
}
