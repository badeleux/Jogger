//
//  AuthTests.swift
//  Jogger
//
//  Created by Kamil Badyla on 03.04.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import XCTest
import EarlGrey
import Fakery

class AuthTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSignUpSignOutSignIn() {
        let faker = Faker()
        let email = faker.name.firstName() + faker.name.lastName() + "@" + faker.internet.domainName()

        let password = faker.internet.password(minimumLength: 8, maximumLength: 16)
        
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("SignUp")).perform(grey_tap())
        EarlGrey.select(elementWithMatcher: self.emailFieldMatcher()).perform(grey_typeText(email))
        EarlGrey.select(elementWithMatcher: self.passwordFieldMatcher()).perform(grey_typeText(password))
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("SignUpAction")).perform(grey_tap())
        conditionVisible(forMatcher: grey_accessibilityID("Profile"), name: "Wait for sign up").wait(withTimeout: 1.0, pollInterval: 0.1)
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("Profile")).perform(grey_tap())
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("SignOut")).perform(grey_tap())
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("SignIn")).perform(grey_tap())
        EarlGrey.select(elementWithMatcher: self.emailFieldMatcher()).perform(grey_typeText(email))
        EarlGrey.select(elementWithMatcher: self.passwordFieldMatcher()).perform(grey_typeText(password))
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("SignInAction")).perform(grey_tap())
        conditionVisible(forMatcher: grey_accessibilityID("Profile"), name: "Wait for sign in").wait(withTimeout: 1.0, pollInterval: 0.1)
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("Profile")).perform(grey_tap())
    }
    
    func conditionVisible(forMatcher matcher: GREYMatcher, name: String) -> GREYCondition {
        return GREYCondition(name: name) { () -> Bool in
            var error: NSError? = nil
            EarlGrey.select(elementWithMatcher: matcher).assert(with: grey_sufficientlyVisible(), error: &error)
            return error == nil
        }
    }
    
    func emailFieldMatcher() -> GREYMatcher {
        return GREYElementMatcherBlock(matchesBlock: { (v: Any?) -> Bool in
            if let emailField = v as? UITextField {
                return emailField.keyboardType == .emailAddress
            }
            return false
        }, descriptionBlock: { (d) in
            d?.appendText("Email Text Field")
        })
    }
    
    func passwordFieldMatcher() -> GREYMatcher {
        return GREYElementMatcherBlock(matchesBlock: { (v: Any?) -> Bool in
            if let emailField = v as? UITextField {
                return emailField.isSecureTextEntry
            }
            return false
        }, descriptionBlock: { (d) in
            d?.appendText("Password Text Field")
        })
    }
    
}
