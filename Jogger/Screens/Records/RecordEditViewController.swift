//
//  RecordEditViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 01.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import UIKit

class RecordEditViewController: UIViewController {
    var recordForm: RecordFormViewController?
    var record: Record?
    var userId: UserId?
    
    @IBAction func save(_ sender: Any) {
        if let uid = userId {
            self.recordForm?.save(forUserId: uid)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.recordForm?.cancel(sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recordForm = segue.destination as? RecordFormViewController {
            self.recordForm = recordForm
            if let r = self.record {
                self.update(record: r)
            }
        }
    }
    
    func update(record: Record) {
        self.recordForm?.recordEditableViewModel.recordID.value = record.recordID
        self.recordForm?.distance.textDidChange(record.distance.description)
        self.recordForm?.time.textDidChange(record.time.description)
        self.recordForm?.date.valueDidChange(record.date)
    }
}
