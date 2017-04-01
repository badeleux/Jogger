//
//  RecordService.swift
//  Jogger
//
//  Created by Kamil Badyla on 31.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol RecordsService {
    func records(forUserId userId: UserId) -> SignalProducer<[Record], NSError> 
}
