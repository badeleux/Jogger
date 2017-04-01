//
//  RecordEditViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import SwiftyFORM
import UIKit

class RecordAddFormViewController: RecordFormViewController {
    
}

class RecordEditFormViewController: RecordFormViewController {
    
}

class RecordFormViewController: FormViewController {
    var recordEditableViewModel: RecordViewModelEditable!
    
    override func populate(_ builder: FormBuilder) {
        builder += SectionHeaderTitleFormItem(title: "Record")
        builder += distance
        builder += time
        builder += date
    }
    
    lazy var distance: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Distance").placeholder("distance in meters")
        instance.keyboardType = .numbersAndPunctuation
        instance.autocorrectionType = .no
        instance.textDidChangeBlock = { s in
            self.recordEditableViewModel.distance.value = s
        }
        return instance
    }()
    
    
    lazy var time: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Time").placeholder("time in seconds")
        instance.keyboardType = .numberPad
        instance.autocorrectionType = .no
        instance.textDidChangeBlock = { s in
            self.recordEditableViewModel.time.value = s
        }
        return instance
    }()
    
    lazy var date: DatePickerFormItem = {
        let instance = DatePickerFormItem()
        instance.maximumDate = Date()
        instance.title("Date")
        instance.valueDidChangeBlock = { v in
            self.recordEditableViewModel.date.value = v
        }
        return instance
    }()
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: Any) {
        self.recordEditableViewModel
            .save()
            .on(completed: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .start()
    }
}
