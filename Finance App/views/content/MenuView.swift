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
    
    var toolbar: ToolbarItemGroup<some View> {
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                print("HI")
            } label: {
                Text("First")
            }
            
            Button {
                viewModel.toggleAuthHistory()
            } label: {
                Text("Auth History")
            }
            .sheet(isPresented: $viewModel.isAuthHistoryShown) {
                Text("HI")
                AuthHistory()
            }
        }
    }
    
    var body: some View {
        NavigationView {
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
            .toolbar {
                toolbar
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
