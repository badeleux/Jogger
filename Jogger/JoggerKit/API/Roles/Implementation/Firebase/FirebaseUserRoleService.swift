//
//  FirebaseUserRoleService.swift
//  Jogger
//
//  Created by Kamil Badyla on 30.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import FirebaseDatabase

class FirebaseUserRoleService: UserRoleService {
    
    let database: FIRDatabase
    
    init(database: FIRDatabase) {
        self.database = database
    }
    
    func role(forUserId userId: UserId) -> SignalProducer<UserRole, NSError> {
        return SignalProducer { o, d in
            self.database
                .reference()
                .child("roles")
                .child(userId)
                .observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    let rawRoles = snapshot.value as? [String:Bool]
                    let highestRole = rawRoles?.keys.flatMap { UserRole(rawValue: $0) }.sorted(by: { $0.0.hashValue > $0.1.hashValue }).first
                    if snapshot.exists(), let role = highestRole  {
                        o.send(value: role)
                        o.sendCompleted()
                    }
                    else {
                        o.send(value: .regular)
                        o.sendCompleted()
                    }
            }) { (error: Error) in
                if let e = error as NSError? {
                    o.send(error: e)
                }
                else {
                    o.send(error: NSError.unknownError())
                }
            }
        }
    }
    
    func setRole(role: UserRole, forUserId userId: UserId) -> SignalProducer<UserRole, NSError> {
        return SignalProducer { o, d in
            self.database
                .reference()
                .child("roles")
                .child(userId)
                .runTransactionBlock({ (data: FIRMutableData) -> FIRTransactionResult in
                    data.value = [role.rawValue : true]
                    return FIRTransactionResult.success(withValue: data)
                }, andCompletionBlock: { (error, success, _) in
                    if success {
                        o.send(value: role)
                        o.sendCompleted()
                    }
                    else if let e = error as NSError? {
                        o.send(error: e)
                    }
                    else {
                        o.send(error: NSError.unknownError())
                    }
                })
            
        }
    }
}
