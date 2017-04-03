//
//  SignUpViewController.swift
//  Jogger
//
//  Created by Kamil Badyla on 21.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import UIKit
import ReactiveSwift
import SwiftyFORM

class SignUpViewController: FormViewController {
    
    // MARK: - DI
    var signUpViewModel: SignUpViewModel? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let signUpCell = self.dataSource?.tableView(self.tableView, cellForRowAt: IndexPath(row: 2, section: 0))
        signUpCell?.accessibilityIdentifier = "SignUpAction"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func populate(_ builder: FormBuilder) {
        builder += SectionHeaderTitleFormItem(title: "Sign Up")
        builder += email
        builder += password
        builder += signUpButton
    }
    
    
    lazy var password: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title(NSLocalizedString("sign_in_password", comment: "")).password().placeholder(NSLocalizedString("sign_in_password", comment: ""))
        instance.keyboardType = .asciiCapable
        instance.autocorrectionType = .no
        instance.submitValidate(CountSpecification.min(4), message: "Length must be minimum 4 digits")
        instance.validate(CountSpecification.max(30), message: "Length must be maximum 6 digits")
        return instance
    }()
    
    
    lazy var email: TextFieldFormItem = {
        let instance = TextFieldFormItem()
        instance.title("Email").placeholder("johndoe@example.com")
        instance.keyboardType = .emailAddress
        instance.submitValidate(CountSpecification.min(6), message: "Length must be minimum 6 letters")
        instance.validate(CountSpecification.max(60), message: "Length must be maximum 60 letters")
        instance.submitValidate(EmailSpecification(), message: "Must be a valid email address")
        return instance
    }()
    
    lazy var signUpButton: ButtonFormItem = {
        let instance = ButtonFormItem()
        instance.title = "Sign Up"
        instance.action = { [weak self] in
            if let vc = self {
                let email = vc.email.value
                let password = vc.password.value
                vc.signUpViewModel?.signUp(email: email, password: password)
                //DebugViewController.showJSON(vc, jsonData: vc.formBuilder.dump())
            }
        }
        return instance
    }()
    
}
