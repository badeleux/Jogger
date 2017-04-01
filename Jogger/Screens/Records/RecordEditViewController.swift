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
    
    @IBAction func save(_ sender: Any) {
        self.recordForm?.save(sender)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.recordForm?.cancel(sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recordForm = segue.destination as? RecordFormViewController {
            self.recordForm = recordForm
        }
    }
}
