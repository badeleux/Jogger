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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
