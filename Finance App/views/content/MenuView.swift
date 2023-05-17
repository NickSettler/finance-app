//
//  MenuView.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import SwiftUI
import FirebaseAuth

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            TabView(selection: $viewModel.selectedItem) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(1)
                
                UserMenuView(size: size, safeArea: safeArea)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .onChange(of: viewModel.selectedItem) {
                if viewModel.selectedItem == 2 {
                    viewModel.isAddPresent = true
                } else {
                    viewModel.oldSelectedItem = $0
                }
            }
            .sheet(isPresented: $viewModel.isAddPresent, onDismiss: {
                viewModel.selectedItem = viewModel.oldSelectedItem
            }) {
                Text("Hello!")
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
