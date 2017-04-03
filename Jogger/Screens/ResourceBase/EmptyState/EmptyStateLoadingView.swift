//
//  EmptyStateLoadingView.swift
//  EDK
//
//  Created by Kamil Badyla on 04.03.2017.
//  Copyright © 2017 Peony Media. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class EmptyStateLoadingView: UIView, LoadingView {
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(activityIndicatorView)
        activityIndicatorView <- Edges(0.0)
        activityIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
