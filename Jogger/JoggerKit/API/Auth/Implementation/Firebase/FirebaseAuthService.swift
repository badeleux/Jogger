//
//  FirebaseAuthService.swift
//  Jogger
//
//  Created by Kamil Badyla on 22.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import FirebaseAuth
import Result

extension FIRUser: User {
    public var userId: UserId {
        return self.uid
    }
}

extension NSError: APIError {
    static func unknownError() -> NSError {
        return NSError(domain: "", code: -1, userInfo: nil)
    }
}

extension Observer where Error: APIError {
    func send(user: Value?, error: Swift.Error?) {
        if let u = user {
            self.send(value: u)
            self.sendCompleted()
        }
        else if let e = error as? Error {
            self.send(error: e)
        }
        else {
            self.send(error: NSError.unknownError() as! Error)
        }
    }
}

public class FirebaseAuthService: AuthService {
    public let currentUser = MutableProperty<User?>(nil)
    
    let auth: FIRAuth?
    let profileService: ProfileService
    
    init(auth: FIRAuth?, profileService: ProfileService) {
        self.auth = auth
        self.profileService = profileService
        self.auth?.addStateDidChangeListener({ [weak self] (_, user: FIRUser?) in
            self?.currentUser.value = user
        })
    }
    
    public func signIn(email: String, password: String) -> SignalProducer<User, NSError> {
        return SignalProducer { [weak self] o, d in
            self?.auth?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                o.send(user: user, error: error)
            })
        }
    }
    
    public func signUp(email: String, password: String) -> SignalProducer<User, NSError> {
        return SignalProducer { [weak self] o, d in
            return self?.auth?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                o.send(user: user, error: error)
            })
        }.flatMap(.latest, transform: { [weak self] (user: User) -> SignalProducer<User, NSError> in
            return self?.profileService.add(profile: Profile(user: user))
                .map { _ in user } ?? .empty
        })
    }
    
    public func signOut() -> SignalProducer<Bool, NSError> {
        return SignalProducer { [weak self] o, d in
            do {
                try self?.auth?.signOut()
                o.send(value: true)
                o.sendCompleted()
            }
            catch let error as NSError {
                o.send(error: error)
            }
            catch {
                o.send(error: NSError.unknownError())
            }
        }
    }
}
