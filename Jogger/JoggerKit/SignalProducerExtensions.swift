//
//  SignalProducerExtensions.swift
//  Jogger
//
//  Created by Kamil Badyla on 30.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

extension SignalProducerProtocol {
    func ignoreError() -> SignalProducer<Value, NoError> {
        return self.producer.flatMapError { _ in return .empty }
    }
}
