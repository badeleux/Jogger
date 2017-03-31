//
//  FirebaseKit.swift
//  Jogger
//
//  Created by Kamil Badyla on 24.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import Firebase
import ReactiveSwift

class FirebaseKit {
    init() {
        FIRApp.configure()
        self.auth?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            user?.getTokenWithCompletion({ (token, error) in
                print("Firebase auth token: " + (token ?? "No token"))
            })
        })
    }
    
    var auth: FIRAuth? {
        return FIRAuth.auth()
    }
    
    var db: FIRDatabase? {
        return FIRDatabase.database()
    }
}
