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
            VStack(alignment: .center, spacing: 24) {
                SettingsProfileCard()
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                List {
                    Section(header: Text("Settings")) {
                        NavigationLink {
                            HStack {}
                        } label: {
                            Text("User data")
                        }
                        
                        NavigationLink {
                            AuthHistory()
                        } label: {
                            Text("Auth history")
                        }
                    }
                    
                    Section(header: Text("Actions")) {
                        
                    }
                }
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
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
}

struct UserMenu_Previews: PreviewProvider {
    static var previews: some View {
        UserMenuView()
    }
}
