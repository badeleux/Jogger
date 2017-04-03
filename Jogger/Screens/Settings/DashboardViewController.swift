//
//  SettingsViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 31.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    var authService: AuthService?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "circle-user-7"), tag: 0)
        self.tabBarItem.title = "Profile"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOut(_ sender: Any) {
        self.authService?.signOut().start()
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
