//
//  RecordsDateFilter.swift
//  Jogger
//
//  Created by Kamil Badyla on 02.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import UIKit
import RangeSeekSlider
import ReactiveSwift

class RecordsDateFilter: UIView, RangeSeekSliderDelegate {
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    let minValue = MutableProperty<Int>(0)
    let maxValue = MutableProperty<Int>(0)

    let minSelectedValue = MutableProperty<Int>(0)
    let maxSelectedValue = MutableProperty<Int>(0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rangeSlider.step = 1.0
        self.rangeSlider.enableStep = true
        
        self.rangeSlider.delegate = self
        self.minValue.producer.on(value: { [weak self] (min) in
            self?.rangeSlider.minValue = CGFloat(min)
        }).start()
        self.maxValue.producer.skipRepeats().on(value: { [weak self] (m) in
            let new = CGFloat(max(m, 0))
            self?.rangeSlider.maxValue = new
            self?.rangeSlider.selectedMaxValue = new
            self?.rangeSlider.maxValue = new //hack to refresh
        }).start()
        self.minValue.producer
            .combineLatest(with: self.maxValue.producer)
            .on(value: { [weak self] _ in self?.updateSelectedValues() })
            .start()
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.updateSelectedValues()
    }
    
    func updateSelectedValues() {
        self.minSelectedValue.value = Int(self.rangeSlider.selectedMinValue)
        self.maxSelectedValue.value = Int(self.rangeSlider.selectedMaxValue)
    }
    
    
}
