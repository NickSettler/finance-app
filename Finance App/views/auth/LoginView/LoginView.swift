//
//  LoginView.swift
//  Finance App
//
//  Created by Nikita Moiseev on 18.03.2023.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Spacer()
                
                TextField("Email", text: $viewModel.emailValue)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $viewModel.passwordValue)
                    .textFieldStyle(RoundedTextFieldStyle())
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
                
                Spacer()
                
                HStack (alignment: .firstTextBaseline) {
                    Text("You do not have an account?")
                        .foregroundColor(Color.TextColorPrimary)
                    
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Sign Up")
                    }
                }
                .font(.headline)
            }
            .padding()
            .background(Color.BackgroundColor)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
