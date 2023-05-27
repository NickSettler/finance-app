//
//  MainViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor class MainViewModel: ObservableObject {
    @Published var isLoggedIn: Bool
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
        self.handle = nil
    }
    
    func handleViewAppear() {
        withAnimation {
            self.isLoggedIn = Auth.auth().currentUser != nil
        }
        
        self.handle = Auth.auth().addStateDidChangeListener { _, user in
            withAnimation {
                self.isLoggedIn = Auth.auth().currentUser != nil
            }
        }
    }
    
    func handleViewDisappear() {
        Auth.auth().removeStateDidChangeListener(self.handle!)
    }
    
    func view() -> some View {
        if isLoggedIn {
            return AnyView(
                MenuView()
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            )
            .id("MenuView")
        }
        
        return AnyView(AuthView())
            .id("AuthView")
    }
}
