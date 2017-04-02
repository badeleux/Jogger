//
//  WeekReportViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 02.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import SwiftyFORM

class WeekReportViewController: FormViewController {
    
    var recordsViewModel: RecordsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordsViewModel.stats.signal.observeValues { [weak self] (stats: RecordStats) in
            self?.avgDistanceFormItem.value(stats.avgDistance.description)
            self?.avgSpeedFormitem.value(stats.avgSpeed.description)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recordsViewModel.refresh()
        self.recordsViewModel.dateRange.value = self.thisWeek()
    }
    
    override func populate(_ builder: FormBuilder) {
        builder += avgSpeedFormitem
        builder += avgDistanceFormItem
    }
    
    lazy var avgSpeedFormitem: StaticTextFormItem = {
        let instance = StaticTextFormItem().title("AVG Speed")
        return instance
    }()
    
    lazy var avgDistanceFormItem: StaticTextFormItem = {
        let instance = StaticTextFormItem().title("AVG Distance")
        return instance
    }()
    
    func thisWeek() -> ClosedRange<Date> {
        let result = Date().startWeek...Date().endWeek
        return result
    }
    
}
