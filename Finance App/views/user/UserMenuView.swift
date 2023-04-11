//
//  UserMenu.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.03.2023.
//

import SwiftUI

struct UserMenuView: View {
    @StateObject private var viewModel = UserMenuViewModel()
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .center, spacing: 24) {
                        SettingsProfileCard()
                        
                        VStack {
                            NavigationLink {
                                HStack {}
                            } label: {
                                Text("User data")
                            }
                            .buttonStyle(.borderedProminent)
                            
                            NavigationLink {
                                AuthHistory()
                            } label: {
                                Text("Auth history")
                            }
                            .buttonStyle(.borderedProminent)
                            
                            NavigationLink {
                                CategoriesView()
                            } label: {
                                Text("Custom categories")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                UserEditView()
                            } label: {
                                Text("Edit")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Anonymous")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct UserMenu_Previews: PreviewProvider {
    static var previews: some View {
        UserMenuView()
    }
}
