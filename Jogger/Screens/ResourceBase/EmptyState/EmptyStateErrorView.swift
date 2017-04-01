//
//  EmptyStateErrorView.swift
//  EDK
//
//  Created by Kamil Badyla on 04.03.2017.
//  Copyright © 2017 Peony Media. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class EmptyStateErrorView: UIView, ErrorView {
    let mainLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainLabel)
        mainLabel.text = "Error"
        mainLabel.textColor = .white
        mainLabel.numberOfLines = 0
        mainLabel.textAlignment = .center
        mainLabel <- Edges(0)
        
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
