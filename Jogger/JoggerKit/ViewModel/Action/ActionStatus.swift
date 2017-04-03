//
//  ActionStatus.swift
//  Jogger
//
//  Created by Kamil Badyla on 22.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift

extension SignalProducerProtocol {
    func on(statusChanged: @escaping ((ActionStatus<Error>) -> Void)) -> SignalProducer<Value, Error> {
        return self.producer.on(
            starting: {
            statusChanged(.loading)
        }, failed: { (e: Self.Error) in
            statusChanged(.error(e))
        }, completed: { 
            statusChanged(.completed)
        })
    }
    
    
}

enum ActionStatus<E: Swift.Error> {
    case none, loading, error(E), completed
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    var error: E? {
        switch self {
        case .error(let e):
            return e
        default:
            return nil
        }
    }
    
    var completed: Bool {
        switch self {
        case .completed:
            return true
        default:
            return false
        }
    }
}
