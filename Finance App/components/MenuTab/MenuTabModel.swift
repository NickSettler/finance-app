//
//  MenuTabModel.swift
//  Finance App
//
//  Created by Никита Моисеев on 17.05.2023.
//

import Foundation

enum MenuTabModel : String, CaseIterable {
    case home = "Home"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .settings:
            return "gear"
        }
    }
    
    var index: Int {
        return MenuTabModel.allCases.firstIndex(of: self) ?? 0
    }
}
