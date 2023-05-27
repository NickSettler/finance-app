//
//  LoginView.swift
//  Finance App
//
//  Created by Никита Моисеев on 18.03.2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $viewModel.emailValue)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text: $viewModel.passwordValue)
                .textContentType(.password)
            
            if (!viewModel.error.isEmpty) {
                Text("\(viewModel.error)")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            Button {
                viewModel.signIn()
            } label: {
                Text("Sign In")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
