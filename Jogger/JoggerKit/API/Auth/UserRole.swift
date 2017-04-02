//
//  UserRole.swift
//  Jogger
//
//  Created by Kamil Badyla on 28.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation

public enum UserRole: String {
    case regular = "regular", userManager = "user_manager", admin = "admin"
    
    var canManageUsers: Bool {
        switch self {
        case .userManager, .admin:
            return true
        default:
            return false
        }
    }
    
    static var roles: [UserRole] {
        return [.regular, .userManager, .admin]
    }
    
    var localizedDescription: String {
        switch self {
        case .regular:
            return "Regular"
        case .admin:
            return "Admin"
        case .userManager:
            return "User Manager"
        }
    }
}
