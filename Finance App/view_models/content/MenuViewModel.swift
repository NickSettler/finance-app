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
    
    func toggleAuthHistory() {
        //        withAnimation {
        self.isAuthHistoryShown.toggle()
        //        }
    }
}
