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
    case add = "Add", edit = "Edit", detail = "Detail"
}

class RecordsViewController: UIViewController, TableViewControllerProtocol, ListResourceBasedViewController {
    
    static let RecordCellReuseID = "RecordCell"

    @IBOutlet weak var recordDateFilter: RecordsDateFilter!
    var viewModel: RecordsViewModel!
    var dataSource = MutableProperty<[Record]?>(nil)
    var userAuthViewModel: UserAuthViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource <~ self.viewModel.resourceData
        self.setUp(content: .records)
        
        if self.isModal() {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(RecordsViewController.back))
        }
        
        let dateForIndex = { [weak self] (index: Int) -> Date? in
            if let array = self?.viewModel.datesFilterValues.value, array.count > index {
                return array[index]
            }
            else {
                return nil
            }
        }
        self.recordDateFilter.maxValue <~ self.viewModel.datesFilterValues.map { $0.count - 1 }
        self.viewModel.dateRange <~ Signal.combineLatest(self.recordDateFilter.minSelectedValue.signal, self.recordDateFilter.maxSelectedValue.signal)
            .map({ (t: (Int, Int)) -> ClosedRange<Date>? in
                if let min = dateForIndex(t.0), let max = dateForIndex(t.1) {
                    return min...max
                }
                return nil
            })
        self.recordDateFilter.fromLabel.reactive.text <~ self.viewModel.dateRange.map { $0?.lowerBound.string() ?? " - " }
        self.recordDateFilter.toLabel.reactive.text <~ self.viewModel.dateRange.map { $0?.upperBound.string() ?? " - " }
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
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
        else if let detailVC = segue.destination as? RecordDetailViewController,
            let selectedIP = self.tableView.indexPathForSelectedRow,
            let record = self.dataSource.value?[selectedIP.row] {
            detailVC.record = record
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
            cell.textLabel?.text = record.date.string()
            cell.detailTextLabel?.text = record.distanceWithUnit().description
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
