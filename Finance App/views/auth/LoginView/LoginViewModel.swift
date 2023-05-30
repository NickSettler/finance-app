//
//  LoginViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 18.03.2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor class LoginViewModel: ObservableObject {
    @Published var emailValue: String = ""
    @Published var passwordValue: String = ""
    @Published var error: String = ""
    
    func signIn() {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: emailValue, password: passwordValue)
                
                let uid = authResult.user.uid
                
                try await UserService.addAuthHistory(by: uid)
            } catch {
                print(error)
            }
        }
    }
}
