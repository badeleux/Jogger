//
//  FirebaseProfileService.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import FirebaseDatabase

class FirebaseProfileService: ProfileService {
    let database: FIRDatabase
    
    init(database: FIRDatabase) {
        self.database = database
    }
    
    func profiles() -> SignalProducer<[Profile], NSError> {
        return SignalProducer { o, d in
            self.database
                .reference()
                .child("profiles")
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
    
    func add(profile: Profile) -> SignalProducer<Profile, NSError> {
        
    }
}
