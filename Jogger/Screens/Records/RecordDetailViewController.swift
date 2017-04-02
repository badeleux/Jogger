//
//  RecordDetailViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import UIKit
import SwiftyFORM

class RecordDetailViewController: FormViewController {
    var record: Record?
    
    override func populate(_ builder: FormBuilder) {
        if let r = record {
            builder += StaticTextFormItem().title("Date").value(r.date.string())
            builder += StaticTextFormItem().title("Distance").value(r.distanceWithUnit().description)
            builder += StaticTextFormItem().title("Time").value(r.timeWithUnit().description)
            builder += StaticTextFormItem().title("AVG Speed").value(r.avgSpeed().description)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
