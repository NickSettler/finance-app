//
//  UserMenu.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.03.2023.
//

import SwiftUI

struct UserMenu: View {
    @StateObject private var viewModel = UserMenuViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack {
                Text("Menu")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .padding(.horizontal, 20)
            
            List {
                SettingsProfileCard()
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                Section(header: Text("Settings")) {
                    Button {
                        // ...
                    } label: {
                        Text("User data")
                    }
                    .buttonStyle(.plain)
//                    Button {
//                        // ...
//                    } label: {
//                        Text("User data")
//                    }
                }
                
                Section(header: Text("Actions")) {
                    
                }
            }
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
//            .content.background(Color.yellow)
//            .listRowInsets(EdgeInsets())
//            .listItemTint(.yellow)
//            .listStyle(.grouped)
//            .background(.white)
        }
        .onAppear {
//            do {
//                viewModel = try UserMenuViewModel()
//            }
        }
    }
}

struct UserMenu_Previews: PreviewProvider {
    static var previews: some View {
        UserMenu()
    }
}
