//
//  MenuViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import Foundation
import SwiftUI

@MainActor class MenuViewModel : ObservableObject {
    @Published var isAddPresent: Bool = false
    @Published var selectedItem = 1
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
