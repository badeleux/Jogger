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

struct DummyAuthService: AuthService {
    let currentUser = MutableProperty<User?>(nil)
    
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

class UserAuthViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("root view state") { 
            context("when user is logged out", { 
                it("is equal to logIn", closure: {
                    //TOOD create user auth view model here
                    let userAuthVM: UserAuthViewModel? = nil
                    expect(userAuthVM!.rootViewState.first()).to(equal(RootViewState.logIn))
                })
            })
        }
    }
}
