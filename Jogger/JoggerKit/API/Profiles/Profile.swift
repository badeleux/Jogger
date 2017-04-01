//
//  Profile.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import Himotoki

struct Profile: Decodable, Encodable {
    let userID: UserId
    let email: String?
    
    init(user: User) {
        self.userID = user.userId
        self.email = user.email ?? ""
    }
    
    init(userID: UserId, email: String?) {
        self.userID = userID
        self.email = email
    }
    
    static func decode(_ e: Extractor) throws -> Profile {
        return try Profile(userID: e <| "id", email: e <|? "email")
    }
    
    func encode() -> Any? {
        return ["email" : email]
    }
    
    
}
