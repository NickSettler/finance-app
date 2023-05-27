//
//  SignUpView.swift
//  Finance App
//
//  Created by Никита Моисеев on 18.03.2023.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            TextField("Email", text: $viewModel.emailString)
                .textFieldStyle(RoundedTextFieldStyle())
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text: $viewModel.passwordString)
                .textFieldStyle(RoundedTextFieldStyle())
            
            SecureField("Password confirmation", text: $viewModel.passwordConfirmString)
                .textFieldStyle(RoundedTextFieldStyle())
            
            Button {
                viewModel.signUp()
            } label: {
                Text("Sign Up")
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .background(Color.BackgroundColor)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
