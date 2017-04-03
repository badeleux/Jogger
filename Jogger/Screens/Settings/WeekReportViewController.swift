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
            self?.avgDistanceFormItem.value(Formatter.runDistanceFormat(dist: stats.avgDistance))
            self?.avgSpeedFormitem.value(Formatter.runSpeedFormat(speed: stats.avgSpeed))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.recordsViewModel.refresh()
        let thisWeek = self.thisWeek()
        self.recordsViewModel.dateRange.value = thisWeek
        self.dates.value = thisWeek.lowerBound.string(dateStyle: .medium, timeStyle: DateFormatter.Style.none, in: nil) + " - " + thisWeek.upperBound.string(dateStyle: .medium, timeStyle: DateFormatter.Style.none, in: nil)
    }
    
    override func populate(_ builder: FormBuilder) {
        builder += dates
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
    
    lazy var dates: StaticTextFormItem = {
        let instance = StaticTextFormItem().title("Dates")
        return instance
    }()
    
    func thisWeek() -> ClosedRange<Date> {
        let result = Date().startWeek...Date().endWeek
        return result
    }
    
}
