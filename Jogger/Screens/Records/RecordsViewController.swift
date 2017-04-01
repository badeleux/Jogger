//
//  RecordsViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 25.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import UIKit
import ReactiveSwift

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordsViewController.RecordCellReuseID, for: indexPath)
        if let record = self.dataSource.value?[indexPath.row] {
            cell.textLabel?.text = record.date.string(format: .extended)
            cell.detailTextLabel?.text = record.distance.description
        }
        return cell
    }
}
