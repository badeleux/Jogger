//
//  EmptyStateContent.swift
//  EDK
//
//  Created by Kamil Badyla on 21.03.2017.
//  Copyright © 2017 Peony Media. All rights reserved.
//

import Foundation

protocol EmptyStateNoDataContent {
    var noDataLocalizedDescrption: String { get }
    var noDataContent: EmptyStateNoDataContent { get }
}

enum EmptyStateContent: EmptyStateNoDataContent {
    case general, records, users
    
    var noDataLocalizedDescrption: String {
        switch self {
        case .general:
            return NSLocalizedString("no_results", comment: "")
        case .records:
            return NSLocalizedString("no_records", comment: "")
        case .users:
            return NSLocalizedString("no_users", comment: "")
        }
    }
    
    var noDataContent: EmptyStateNoDataContent {
        return self
    }
}
