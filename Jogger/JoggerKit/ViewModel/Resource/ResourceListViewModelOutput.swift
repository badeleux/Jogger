//
//  ResourceListViewModelOutput.swift
//  Jogger
//
//  Created by Kamil Badyla on 31.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol ResourceViewModelOutput {
    associatedtype E: Swift.Error
    associatedtype D
    var resourceStatus: Signal<ActionStatus<E>, NoError> { get }
    var resourceData: Signal<D, NoError> { get }
}
