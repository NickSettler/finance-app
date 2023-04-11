//
//  HomeView.swift
//  Finance App
//
//  Created by Никита Моисеев on 11.04.2023.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    var body: some View {
        VStack {
            ExpensesChart()
                .frame(maxHeight: 300)
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
