//
//  MenuViewModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import Foundation
import SwiftUI

@MainActor class MenuViewModel : ObservableObject {
    @Published var isAuthHistoryShown : Bool = false
    @Published var isUserMenuShown : Bool = false
    
    func toggleAuthHistory() {
        self.isAuthHistoryShown.toggle()
    }
    
    func toggleUserMenu() {
        self.isUserMenuShown.toggle()
    }
}
