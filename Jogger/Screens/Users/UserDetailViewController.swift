//
//  UserDetailViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 02.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import UIKit
import SwiftyFORM

class UserDetailViewController: FormViewController {

    var userAuthViewModel: UserAuthViewModel!
    var profileViewModel: ProfileViewModel!
    
    override func populate(_ builder: FormBuilder) {
        if let profile = self.profileViewModel.profileProperty.value {
            builder += StaticTextFormItem().title("UserID").value(profile.userID)
            builder += StaticTextFormItem().title("E-Mail").value(profile.email!)
            builder += self.roleFormItem
            if userAuthViewModel.role.value == .admin {
                let records = ButtonFormItem().title("Records")
                records.action = {
                    let recordsVC = self.storyboard!.records(forUserId: profile.userID)
                    self.present(recordsVC, animated: true, completion: nil)
                }
                builder += records
            }
        }
    }
    
    lazy var roleFormItem: SegmentedControlFormItem = {
        let instance = SegmentedControlFormItem()
        instance.title("Role")
        instance.itemsArray(UserRole.roles.map { $0.localizedDescription })
        instance.valueDidChangeBlock = { [weak self] index in
            let role = UserRole.roles[index]
            self?.profileViewModel.set(role: role).showError().start()
        }
        return instance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileViewModel.roleProperty
            .signal
            .map { UserRole.roles.index(of: $0) }
            .skipNil()
            .observeValues { [weak self] index in
                self?.roleFormItem.value = index
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
