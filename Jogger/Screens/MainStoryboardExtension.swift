//
//  MainStoryboardExtension.swift
//  Jogger
//
//  Created by Kamil Badyla on 02.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import UIKit

enum ViewControllerID: String {
    case recordNav = "RecordsNav"
    case usersNav = "UsersNav"
}

extension UIStoryboard {
    func records(forUserId userId: UserId) -> UINavigationController {
        
        if let navController = self.instantiateViewController(withIdentifier: ViewControllerID.recordNav.rawValue) as? UINavigationController,
            let records = navController.viewControllers.first as? RecordsViewController {
            records.viewModel.userId(uid: userId)
            return navController
        }
        return UINavigationController()
        
    }
}
