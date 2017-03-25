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

class RootViewController: UIViewController {
    let loggedOut: UIViewController
    let loggedIn: UIViewController
    let authService: AuthService
    
    var currentVC: UIViewController?
    
    init(loggedOut: UIViewController, loggedIn: UIViewController, authService: AuthService) {
        self.loggedOut = loggedOut
        self.loggedIn = loggedIn
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authService
            .currentUser
            .on { [weak self] (user: User?) in
                self?.setUp(forUser: user)
            }
            .start()
    }
    
    func setUp(forUser user: User?) {
        let newController = user != nil ? loggedIn : loggedOut
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
}
