//
//  UsersViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 25.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import UIKit
import ReactiveSwift

class UsersViewController: UIViewController, TableViewControllerProtocol, ListResourceBasedViewController {
    
    static let UserCellID = "UserCell"

    var viewModel: ProfilesViewModel!
    var dataSource = MutableProperty<Array<Profile>?>(nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem = UITabBarItem(title: "Users", image: UIImage(named: "book-simple-7"), tag: 0)
        self.title = "Users"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource <~ self.viewModel.resourceData
        self.setUp(content: .users)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? UserDetailViewController,
            let selectedIP = self.tableView.indexPathForSelectedRow,
            let profile = self.dataSource.value?[selectedIP.row]{
                detailVC.profileViewModel.set(profile: profile)
        }
    }

}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersViewController.UserCellID, for: indexPath)
        if let user = self.dataSource.value?[indexPath.row] {
            cell.textLabel?.text = user.email
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.value?.count ?? 0
    }
}
