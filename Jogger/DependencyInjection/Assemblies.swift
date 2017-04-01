//
//  Assemblies.swift
//  Jogger
//
//  Created by Kamil Badyla on 27.03.2017.
//  Copyright © 2017 Science Spir.IT. All rights reserved.
//

import Foundation
import Swinject
import Firebase
import SwinjectStoryboard

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FirebaseKit.self, factory: { _ in FirebaseKit() }).inObjectScope(.container)
        container.register(FIRAuth.self, factory: { r in r.resolve(FirebaseKit.self)!.auth! })
        container.register(FIRDatabase.self, factory: { r in r.resolve(FirebaseKit.self)!.db! })
        container.register(AuthService.self) { r in FirebaseAuthService(auth: r.resolve(FIRAuth.self)) }
        container.register(UserRoleService.self) { r in FirebaseUserRoleService(database: r.resolve(FIRDatabase.self)!) }.inObjectScope(.container)
        container.register(ProfileService.self) { r in FirebaseProfileService() }.inObjectScope(.container)
        container.register(RecordsService.self) { r in FirebaseRecordService(database: r.resolve(FIRDatabase.self)!) }.inObjectScope(.container)
    }
}

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SignInViewModel.self) { r in SignInViewModel(authService: r.resolve(AuthService.self)! )}
        container.register(SignUpViewModel.self) { r in SignUpViewModel(authService: r.resolve(AuthService.self)! )}
        container.register(UserViewModel.self) { (r, user) in
            return UserViewModel(user: user)
        }
        container.register(UserAuthViewModel.self) { r in
            UserAuthViewModel(authService: r.resolve(AuthService.self)!, resolver: r, rolesService: r.resolve(UserRoleService.self)!)
        }.inObjectScope(.container)
        container.register(RecordsViewModel.self) { (r: Resolver) -> RecordsViewModel in
            return RecordsViewModel(recordsService: r.resolve(RecordsService.self)!)
        }
        container.register(RecordAddViewModel.self) { r in
            return RecordAddViewModel(recordsService: r.resolve(RecordsService.self)!, userAuthViewModel: r.resolve(UserAuthViewModel.self)!)
        }
        container.register(RecordEditViewModel.self) { r in
            return RecordEditViewModel(recordsService: r.resolve(RecordsService.self)!, userAuthViewModel: r.resolve(UserAuthViewModel.self)!)
        }
    }
}

class ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SwinjectStoryboard.self) { (r: Resolver) -> SwinjectStoryboard in
            return SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
        }.inObjectScope(.container)
        
        container.storyboardInitCompleted(RootViewController.self) { (r, c) in
            c.mainStoryboard = r.resolve(SwinjectStoryboard.self)
            c.userAuthViewModel = r.resolve(UserAuthViewModel.self)
        }
        
        container.storyboardInitCompleted(SignUpViewController.self, initCompleted: { r, c in
            c.signUpViewModel = r.resolve(SignUpViewModel.self)
        })
        container.storyboardInitCompleted(LoginViewController.self, initCompleted: { r, c in })
        container.storyboardInitCompleted(SignInViewController.self, initCompleted: { r, c in
            c.signInViewModel = r.resolve(SignInViewModel.self)
        })
        container.storyboardInitCompleted(SettingsViewController.self) { (r, c) in
            c.authService = r.resolve(AuthService.self)
        }
        container.storyboardInitCompleted(RecordsViewController.self) { (r, c) in
            c.viewModel = r.resolve(RecordsViewModel.self)
            c.userAuthViewModel = r.resolve(UserAuthViewModel.self)
        }
        container.storyboardInitCompleted(RecordAddFormViewController.self) { (r, c) in
            c.recordEditableViewModel = r.resolve(RecordAddViewModel.self)
        }
        container.storyboardInitCompleted(RecordEditFormViewController.self) { (r, c) in
            c.recordEditableViewModel = r.resolve(RecordEditViewModel.self)
        }
        
    }
}
