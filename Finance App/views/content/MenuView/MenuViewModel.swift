//
//  MenuViewModel.swift
//  Finance App
//
//  Created by Nikita Moiseev on 22.03.2023.
//

import Foundation
import SwiftUI

@MainActor class MenuViewModel : ObservableObject {
    @Published var isAddPresent: Bool = false
    @Published var activeTab: MenuTabModel = .home
    @Published var tabShapePosition: CGPoint = .zero
    @Published var oldSelectedItem = 1
    @Published var isAuthHistoryShown : Bool = false
    @Published var isUserMenuShown : Bool = false
    
    func toggleIsAddPresent() {
        self.isAddPresent.toggle()
    }
    
    func toggleAuthHistory() {
        self.isAuthHistoryShown.toggle()
    }
    
    func toggleUserMenu() {
        self.isUserMenuShown.toggle()
    }
}
