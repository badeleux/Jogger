//
//  UserAuthViewModelSpec.swift
//  Jogger
//
//  Created by Kamil Badyla on 30.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ReactiveSwift
import Swinject
@testable import Jogger

class RootViewStateSpec: QuickSpec {
    override func spec() {
        describe("root view state equal method") {
            it("returns correct result for each comparison", closure: { 
                let states = [RootViewState.logIn, .admin, .manager, .regular]
                for state1 in states {
                    for state2 in states {
                        if states.index(of: state1) == states.index(of: state2) {
                            expect(state1).to(equal(state2))
                        }
                        else {
                            expect(state1).toNot(equal(state2))
                        }
                    }
                }
            })
        }
    }
}

struct AuthServiceStub: AuthService {
    let currentUser = MutableProperty<User?>(nil)
    
    init(user: User?) {
        self.currentUser.value = user
    }
    
    func signOut() -> SignalProducer<Bool, NSError> {
        return .empty
    }
    
    func signIn(email: String, password: String) -> SignalProducer<User, NSError> {
        return .empty
    }
    
    func signUp(email: String, password: String) -> SignalProducer<User, NSError> {
        return .empty
    }
}

struct UserRoleServiceStub: UserRoleService {
    
    var role: UserRole?
    init(role: UserRole?) {
        self.role = role
    }
    
    func role(forUserId userId: UserId) -> SignalProducer<UserRole, NSError> {
        return .init(value: self.role!)
    }
    
    func setRole(role: UserRole, forUserId userId: UserId) -> SignalProducer<UserRole, NSError> {
        return .init(value: self.role!)
    }
}

struct UserStub: User {
    var userId: UserId = "0"
    var email: String? = nil
}

class UserAuthViewModelSpec: QuickSpec {
    
    override func spec() {
        var container: Container!
        beforeEach {
            container = Container()

            container.register(UserAuthViewModel.self, factory: { (resolver: Resolver, user: User?, role: UserRole) -> UserAuthViewModel in
                return UserAuthViewModel(authService: AuthServiceStub(user: user), resolver: resolver, rolesService: UserRoleServiceStub(role: role))
            })
        }
        
        describe("root view state") { 
            context("when user is logged out", { 
                it("is equal to logIn", closure: {
                    let user: User? = nil
                    let userAuthVM: UserAuthViewModel? = container.resolve(UserAuthViewModel.self, arguments: user, UserRole.regular)
                    expect(userAuthVM!.rootViewState.value).to(equal(RootViewState.logIn))
                })
            })
            context("when user is logged in state depends on role", {
                context("role is regular", { 
                    it("state is regular", closure: {
                        let user: User? = UserStub()
                        let userAuthVM: UserAuthViewModel? = container.resolve(UserAuthViewModel.self, arguments: user, UserRole.regular)
                        expect(userAuthVM!.rootViewState.value).toEventually(equal(RootViewState.regular))
                    })
                })
                
                context("role is user_manager", {
                    it("state is manager", closure: {
                        let user: User? = UserStub()
                        let userAuthVM: UserAuthViewModel? = container.resolve(UserAuthViewModel.self, arguments: user, UserRole.userManager)
                        expect(userAuthVM!.rootViewState.value).toEventually(equal(RootViewState.manager))
                    })
                })
                
                context("role is admin", {
                    it("state is admin", closure: {
                        let user: User? = UserStub()
                        let userAuthVM: UserAuthViewModel? = container.resolve(UserAuthViewModel.self, arguments: user, UserRole.admin)
                        expect(userAuthVM!.rootViewState.value).toEventually(equal(RootViewState.admin))
                    })
                })

            })
        }
    }
}
