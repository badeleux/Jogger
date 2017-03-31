//
//  RootViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 25.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import UIKit
import EasyPeasy
import Swinject

class RootViewController: UIViewController {
    var mainStoryboard: UIStoryboard? = nil
    var userAuthViewModel: UserAuthViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userAuthViewModel!
            .rootViewState
            .skipRepeats()
            .observeValues { [weak self] (state: RootViewState) in
                self?.setUp(forState: state)
            }
 
        
    }

    var currentVC: UIViewController? = nil
    
    func setUp(forState state: RootViewState) {
        let newController = self.viewController(forState: state)
        if let vc = currentVC, vc != newController {
            self.transition(from: vc, to: newController, duration: 0.0, options: .allowUserInteraction, animations: nil, completion: nil)
        }
        else {
            self.addChildViewController(newController)
            self.view.addSubview(newController.view)
            newController.view <- Edges(0)
            newController.didMove(toParentViewController: self)
        }
    }
    
    func viewController(forState state: RootViewState) -> UIViewController {
        switch state {
        case .logIn:
            return self.mainStoryboard!.instantiateViewController(withIdentifier: "LoginNav")
        case .regular:
            let settingsVC = self.mainStoryboard!.instantiateViewController(withIdentifier: "SettingsVC")
            let recordsVC = self.mainStoryboard!.instantiateViewController(withIdentifier: "RecordsVC")
            let tabBar = UITabBarController()
            tabBar.viewControllers = [recordsVC, settingsVC]
            return tabBar
        default:
            let settingsVC = self.mainStoryboard!.instantiateViewController(withIdentifier: "SettingsVC")
            let recordsVC = self.mainStoryboard!.instantiateViewController(withIdentifier: "RecordsVC")
            let usersVC = self.mainStoryboard!.instantiateViewController(withIdentifier: "UsersVC")
            let tabBar = UITabBarController()
            tabBar.viewControllers = [recordsVC, usersVC, settingsVC]
            return tabBar
        }
    }
 
}
