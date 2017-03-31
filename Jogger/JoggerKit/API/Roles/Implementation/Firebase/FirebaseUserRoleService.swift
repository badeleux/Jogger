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
                    if snapshot.exists(), let rawRole = snapshot.value as? String, let ur = UserRole(rawValue: rawRole)  {
                        o.send(value: ur)
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
}
