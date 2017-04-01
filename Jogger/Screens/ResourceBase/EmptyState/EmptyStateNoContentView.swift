    //
//  EmptyStateNoContentView.swift
//  EDK
//
//  Created by Kamil Badyla on 04.03.2017.
//  Copyright © 2017 Peony Media. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy

class EmptyStateNoContentView: UIView, EmptyView {
    let mainLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainLabel)
        mainLabel.text = NSLocalizedString("No Content", comment: "")
        mainLabel.textColor = .white
        mainLabel <- Center(0.0)
        
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func customize(content: EmptyStateNoDataContent) {
        self.mainLabel.text = content.noDataLocalizedDescrption
    }
}
