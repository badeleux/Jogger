//
//  RecordsViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 25.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import UIKit
import ReactiveSwift
import MGSwipeTableCell

enum RecordsSegue: String {
    case add = "Add", edit = "Edit"
}

class RecordsViewController: UIViewController, TableViewControllerProtocol, ListResourceBasedViewController {
    
    static let RecordCellReuseID = "RecordCell"

    var viewModel: RecordsViewModel!
    var dataSource = MutableProperty<[Record]?>(nil)
    var userAuthViewModel: UserAuthViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userAuthViewModel.currentUser.producer
            .skipNil()
            .map { $0.userId }
            .skipRepeats()
            .on { [weak self] (uid: UserId) in
                self?.viewModel.userId(uid: uid)
            }
            .start()
        self.dataSource <~ self.viewModel.resourceData
        self.setUp(content: .records)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let recordEdit = navController.viewControllers.first as? RecordEditViewController,
            let record = sender as? Record {
            recordEdit.record = record
        }
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsViewController.RecordCellReuseID, for: indexPath) as! MGSwipeTableCell
        if let record = self.dataSource.value?[indexPath.row] {
            cell.textLabel?.text = record.date.string(format: .extended)
            cell.detailTextLabel?.text = record.distance.description
            let delete = MGSwipeButton(title: "Delete", backgroundColor: UIColor.red, callback: { (cell: MGSwipeTableCell) -> Bool in
                if let recordId = record.recordID {
                    self.viewModel.delete(recordID: recordId).start()
                }
                return true
            })
            
            let edit = MGSwipeButton(title: "Edit", backgroundColor: UIColor.green, callback: { (cell: MGSwipeTableCell) -> Bool in
                self.performSegue(withIdentifier: RecordsSegue.edit.rawValue, sender: record)
                return true
            })
            
            cell.rightButtons = [delete, edit]
        }
        return cell
    }
}
