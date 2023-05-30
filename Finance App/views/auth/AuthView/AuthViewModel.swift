//
//  AuthViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 18.03.2023.
//

import SwiftUI
import Foundation

enum AUTH_VIEWS: String {
    case signin
    case signup
}

@MainActor class AuthViewModel: ObservableObject {
    @Published var currentView: AUTH_VIEWS = .signin
    
    func goToSignIn() {
        currentView = .signin
    }
    
    func goToSignUp() {
        currentView = .signup
    }
    
    func view() -> some View {
        switch currentView {
        case .signin: return AnyView(LoginView()).id("SignIn")
        case .signup: return AnyView(SignUpView()).id("SignUp")
        }
    }
}
