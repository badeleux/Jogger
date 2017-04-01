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
    
    init(database: FIRDatabase) {
        self.database = database
    }
    
    func records(forUserId userId: UserId) -> SignalProducer<[Record], NSError> {
        return SignalProducer { o, d in
            self.database
                .reference()
                .child("records")
                .child(userId)
                .observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    let rawRecords = snapshot.value as? [String:Any]
                    
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
