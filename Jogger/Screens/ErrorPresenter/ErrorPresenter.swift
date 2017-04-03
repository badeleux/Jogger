//
//  ErrorPresenter.swift
//  Jogger
//
//  Created by Kamil Badyla on 25.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import ReactiveSwift
import SwiftMessages

extension SignalProducerProtocol {
    func showError() -> SignalProducer<Value, Error> {
        return self.on(failed: { (error: Self.Error) in
            let view = MessageView.viewFromNib(layout: .CardView)
            view.configureTheme(.error)
            view.configureDropShadow()
            let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
            view.configureContent(title: "", body: error.localizedDescription, iconText: iconText)
            view.button?.isHidden = true
            SwiftMessages.show(view: view)
        })
    }
}
