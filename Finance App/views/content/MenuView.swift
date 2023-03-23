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
        TabView {
            
            AuthHistory()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Auth History")
                }
            
            VStack {
                Text("Hello, World! You are logged in!")
                Button {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        print("cant sign out")
                    }
                } label: {
                    Text("sign out")
                }
                .buttonStyle(.borderedProminent)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            UserMenu()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
