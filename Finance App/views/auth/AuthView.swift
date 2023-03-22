//
//  AuthView.swift
//  Finance App
//
//  Created by Никита Моисеев on 18.03.2023.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            viewModel.view()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
