//
//  SignUpViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 18.03.2023.
//

import Foundation
import FirebaseAuth

@MainActor class SignUpViewModel: ObservableObject {
    @Published var emailString: String = ""
    @Published var passwordString: String = ""
    @Published var passwordConfirmString: String = ""
    
    @Published private var error: String?
    
    func signUp() {
        Task {
            if (passwordString != passwordConfirmString) {
                error = "Passwords do not match."
                return
            }
            
            do {
                let authResult = try await Auth.auth().createUser(withEmail: emailString, password: passwordString)
                
                _ = try await Auth.auth().signIn(withEmail: emailString, password: passwordString)
                
                let uid = authResult.user.uid
                
                _ = try await UserService.addAuthHistory(by: uid)
            } catch {
                print(error)
            }
        }
    }
}
