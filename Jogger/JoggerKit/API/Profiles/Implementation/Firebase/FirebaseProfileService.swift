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
    let firebaseMapper: FirebaseMapper

    
    init(database: FIRDatabase) {
        self.database = database
        self.firebaseMapper = FirebaseMapper()
    }
    
    func profiles() -> SignalProducer<[Profile], NSError> {
        return SignalProducer { o, d in
            self.database
                .reference()
                .child("profiles")
                .observeSingleEvent(of: .value, with: { [weak self] (snapshot: FIRDataSnapshot) in
                    let result = self?.firebaseMapper.mapToArray(data: snapshot, toArrayWith: Profile.self)
                    if let e = result?.error {
                        o.send(error: e)
                    }
                    else {
                        o.send(value: result?.value ?? [])
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
        return SignalProducer { o, d in
            self.database.reference()
                .child("profiles")
                .child(profile.userID)
                .runTransactionBlock({ (data: FIRMutableData) -> FIRTransactionResult in
                    data.value = profile.encode()
                    return FIRTransactionResult.success(withValue: data)
                }, andCompletionBlock: { (error, success, _) in
                    if success {
                        o.send(value: profile)
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
