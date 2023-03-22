//
//  SignUpViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 18.03.2023.
//

import Foundation

@MainActor class SignUpViewModel: ObservableObject {
    @Published var emailString: String = ""
    @Published var passwordString: String = ""
    @Published var passwordConfirmString: String = ""
    
    @Published private var error: String?
    
    func signUp() {
        if (passwordString != passwordConfirmString) {
            error = "Passwords do not match."
            return
        }
    }
}
