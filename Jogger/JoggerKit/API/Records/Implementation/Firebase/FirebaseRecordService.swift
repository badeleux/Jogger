//
//  FirebaseRecordService.swift
//  Jogger
//
//  Created by Kamil Badyla on 31.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import FirebaseDatabase

class FirebaseRecordService: RecordsService {
    
    let database: FIRDatabase
    let firebaseMapper: FirebaseMapper
    
    init(database: FIRDatabase) {
        self.database = database
        self.firebaseMapper = FirebaseMapper()
    }
    
    func records(forUserId userId: UserId) -> SignalProducer<[Record], NSError> {
        return SignalProducer { o, d in
            self.database
                .reference()
                .child("records")
                .child(userId)
                .observeSingleEvent(of: .value, with: { [weak self] (snapshot: FIRDataSnapshot) in
                    let result = self?.firebaseMapper.mapToArray(data: snapshot, toArrayWith: Record.self)
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
    
    func add(record: Record, forUserId userId: UserId) -> SignalProducer<Record, NSError> {
        return SignalProducer { o, d in
            self.database.reference()
                .child("records")
                .child(userId)
                .childByAutoId()
                .runTransactionBlock({ (data: FIRMutableData) -> FIRTransactionResult in
                    data.value = record.encode()
                    return FIRTransactionResult.success(withValue: data)
                }, andCompletionBlock: { (error, success, _) in
                    if success {
                        o.send(value: record)
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
