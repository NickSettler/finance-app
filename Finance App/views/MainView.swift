//
//  MainView.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        viewModel.view()
            .onAppear {
                viewModel.handleViewAppear()
            }
            .onDisappear {
                viewModel.handleViewDisappear()
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
